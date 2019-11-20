USE [HuongVietRestaurant]
GO

--Lỗi Unrepeatable Read
--Mô tả: Khách hàng tìm kiếm danh sách món dưới 50.000. Trong lúc đó quản lý cập nhật giá 1 món ăn giá từ dưới 50.000 thành trên 50.000 -> dẫn đến món ăn nằm ngoài danh sách khách hàng tìm kiếm.

--T1: Khách hàng tìm kiếm danh sách món có giá dưới @price
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T1_ANHOA', 'p') is not null DROP PROC PROC_UNREPEATABLEREAD_T1_ANHOA
GO
CREATE PROC PROC_UNREPEATABLEREAD_T1_ANHOA @id_agency nchar(10), @price int
AS
BEGIN TRAN
	SELECT D.id_dish, T.type_dish_name, D.dish_name, A.agency_name, M.unit, D.price
	FROM DISH D, AGENCY A, MENU M, TYPE_DISH T
	WHERE T.id_type_dish = D.type_dish AND M.id_dish = D.id_dish AND M.id_agency = A.id_agency AND D.price <= @price
	ORDER BY D.price ASC
	WAITFOR DELAY '00:00:15'
	SELECT D.id_dish, T.type_dish_name, D.dish_name, A.agency_name, M.unit, D.price
	FROM DISH D, AGENCY A, MENU M, TYPE_DISH T
	WHERE T.id_type_dish = D.type_dish AND M.id_dish = D.id_dish AND M.id_agency = A.id_agency AND D.price <= @price
	ORDER BY D.price ASC
COMMIT TRAN  

--T2: Quản lý thực hiện cập nhật giá một món thuộc danh sách người dùng tìm kiếm (cập nhật giá cao hơn @price của T1)
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T2_ANHOA', 'p') is not null DROP PROC PROC_UNREPEATABLEREAD_T2_ANHOA
GO
CREATE PROC PROC_UNREPEATABLEREAD_T2_ANHOA @id_dish nchar(10), @price int
AS
BEGIN TRAN
	UPDATE DISH
	SET price = @price
	WHERE id_dish = @id_dish
COMMIT TRAN

--Hướng dẫn kiểm tra.
--Bước 1: Chạy lệnh gọi Proc T1, khách hàng xem danh sách món tại chi nhánh ag_1 có giá dưới 50000.
EXEC PROC_UNREPEATABLEREAD_T1_ANHOA 'ag_1', 50000
--Bước 2: Trong thời gian trễ 15 giây, chạy lệnh gọi Proc T2, quản lý cập nhật giá món dish_1 (món có giá dưới 50000 và có ở chi nhánh ag_1) thành 70000.
EXEC PROC_UNREPEATABLEREAD_T2_ANHOA 'dish_5', 70000
--Xem kết quả: Lần đầu T1 đọc danh sách các món ăn vẫn xuất hiện món dish_1. Tuy nhiên sau khi quản lý cập nhật thì món dish_1 không còn trong danh sách đó nữa

--Giải quyết lỗi: Ta sử dụng mức cô lập REPEATABLE READ cho transaction T1.
IF OBJECT_ID('PROC_FIX_UNREPEATABLEREAD_ANHOA', 'p') is not null DROP PROC PROC_FIX_UNREPEATABLEREAD_ANHOA
GO
CREATE PROC PROC_FIX_UNREPEATABLEREAD_ANHOA @id_agency nchar(10), @price int
AS
BEGIN TRAN
SET TRAN ISOLATION LEVEL REPEATABLE READ
	SELECT D.id_dish, T.type_dish_name, D.dish_name, A.agency_name, M.unit, D.price
	FROM DISH D, AGENCY A, MENU M, TYPE_DISH T
	WHERE T.id_type_dish = D.type_dish AND M.id_dish = D.id_dish AND M.id_agency = A.id_agency AND D.price <= @price
	ORDER BY D.price ASC
	WAITFOR DELAY '00:00:15'
	SELECT D.id_dish, T.type_dish_name, D.dish_name, A.agency_name, M.unit, D.price
	FROM DISH D, AGENCY A, MENU M, TYPE_DISH T
	WHERE T.id_type_dish = D.type_dish AND M.id_dish = D.id_dish AND M.id_agency = A.id_agency AND D.price <= @price
	ORDER BY D.price ASC
COMMIT TRAN     
