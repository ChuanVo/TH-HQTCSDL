USE [HuongVietRestaurant]
GO

--============> UNREPEATABLE READ <==========

--AnHoa

--Mô tả: Khách hàng tìm kiếm danh sách món dưới 50.000. Trong lúc đó quản lý cập nhật giá 1 món ăn giá từ dưới 50.000 thành trên 50.000 -> dẫn đến món ăn nằm ngoài danh sách khách hàng tìm kiếm.

--TRANSACTION 1:
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
EXEC PROC_UNREPEATABLEREAD_T1_ANHOA 'ag_1', 50000

--TRANSACTION 2:
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T2_ANHOA', 'p') is not null DROP PROC PROC_UNREPEATABLEREAD_T2_ANHOA
GO
CREATE PROC PROC_UNREPEATABLEREAD_T2_ANHOA @id_dish nchar(10), @price int
AS
BEGIN TRAN
	UPDATE DISH
	SET price = @price
	WHERE id_dish = @id_dish
COMMIT TRAN
EXEC PROC_UNREPEATABLEREAD_T2_ANHOA 'dish_5', 70000

--TRANSACTION 1 FIX:
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T1_ANHOA', 'p') is not null DROP PROC PROC_UNREPEATABLEREAD_T1_ANHOA
GO
CREATE PROC PROC_UNREPEATABLEREAD_T1_ANHOA @id_agency nchar(10), @price int
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
EXEC PROC_UNREPEATABLEREAD_T1_ANHOA 'ag_1', 50000
