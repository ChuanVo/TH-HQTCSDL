USE HuongVietRestaurant
GO
--===============> TEST CASE 20 <==============

/*
- TestCase20: 
- Tình huống: Khách hàng tìm kiếm danh sách món dưới 50.000. Trong lúc đó quản lý cập nhật giá 1 món ăn giá từ dưới 50.000 thành trên 50.000 -> dẫn đến món ăn nằm ngoài danh sách khách hàng tìm kiếm.
- Hướng dẫn sử dụng: 
	+ Bước 1: Chạy TRANSACTION T1 
	+ Bước 2: Trong vòng 15 giây kể từ khi chạy TRANSACTION T1 ta chạy TRANSACTION T2
*/
--TRANSACTION 1:
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T1_ANHOA', 'p') is not null DROP PROC PROC_UNREPEATABLEREAD_T1_ANHOA
GO
CREATE PROC PROC_UNREPEATABLEREAD_T1_ANHOA @id_agency nchar(10), @price int
AS
BEGIN TRAN
	SELECT M.id_agency, D.id_dish, M.unit, D.dish_name, D.type_dish, D.image, D.price
	FROM MENU M JOIN DISH D 
	ON id_agency = @id_agency AND M.id_dish = D.id_dish AND M.isActive = 1 AND D.price < @price

	WAITFOR DELAY '00:00:15'

	SELECT M.id_agency, D.id_dish, M.unit, D.dish_name, D.type_dish, D.image, D.price
	FROM MENU M JOIN DISH D 
	ON id_agency = @id_agency AND M.id_dish = D.id_dish AND M.isActive = 1 AND D.price < @price
COMMIT TRAN  


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


--TRANSACTION 1 FIX:
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T1_ANHOA', 'p') is not null DROP PROC PROC_UNREPEATABLEREAD_T1_ANHOA
GO
CREATE PROC PROC_UNREPEATABLEREAD_T1_ANHOA @id_agency nchar(10), @price int
AS
BEGIN TRAN
SET TRAN ISOLATION LEVEL REPEATABLE READ
	SELECT M.id_agency, D.id_dish, M.unit, D.dish_name, D.type_dish, D.image, D.price
	FROM MENU M JOIN DISH D 
	ON id_agency = @id_agency AND M.id_dish = D.id_dish AND M.isActive = 1 AND D.price < @price

	--WAITFOR DELAY '00:00:15'

	SELECT M.id_agency, D.id_dish, M.unit, D.dish_name, D.type_dish, D.image, D.price
	FROM MENU M JOIN DISH D 
	ON id_agency = @id_agency AND M.id_dish = D.id_dish AND M.isActive = 1 AND D.price < @price
COMMIT TRAN     


--T1
EXEC PROC_UNREPEATABLEREAD_T1_ANHOA 'ag_1', 50000

--T2
EXEC PROC_UNREPEATABLEREAD_T2_ANHOA 'dish_5', 70000

--T1(FIXED)
EXEC PROC_UNREPEATABLEREAD_T1_ANHOA 'ag_1', 50000