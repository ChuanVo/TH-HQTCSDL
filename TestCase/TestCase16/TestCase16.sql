USE HuongVietRestaurant
GO
--===============> TEST CASE 16 <==============

/*
- TestCase16: 
- Tình huống: Khách A xem danh sách các món ăn tại chi nhánh 1 có  SL >=1, khách B mua hết 1 món trong đó ( update SL = 0)
- Hướng dẫn sử dụng: 
	+ Bước 1: Chạy TRANSACTION T1 
	+ Bước 2: Trong vòng 15 giây kể từ khi chạy TRANSACTION T1 ta chạy TRANSACTION T2
*/
--TRANSACTION 1--
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T1_TRUNGDUC', N'P') IS NOT NULL DROP PROC PROC_UNREPEATABLEREAD_T1_TRUNGDUC
GO
CREATE PROC PROC_UNREPEATABLEREAD_T1_TRUNGDUC
	@id_agency nchar(10)
AS
BEGIN TRAN

	SELECT M.id_agency, D.id_dish, M.unit, D.dish_name, D.type_dish, D.image, D.price
	FROM MENU M JOIN DISH D 
	ON id_agency = @id_agency AND M.id_dish = D.id_dish AND M.isActive = 1 AND M.unit >= 1

	WAITFOR DELAY '00:00:15'

	SELECT M.id_agency, D.id_dish, M.unit, D.dish_name, D.type_dish, D.image, D.price
	FROM MENU M JOIN DISH D 
	ON id_agency = @id_agency AND M.id_dish = D.id_dish AND M.isActive = 1 AND M.unit >= 1
	
COMMIT TRAN
GO


 --TRANSACTION 2--
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T2_TRUNGDUC', N'P') IS NOT NULL DROP PROC PROC_UNREPEATABLEREAD_T2_TRUNGDUC
GO
CREATE PROC PROC_UNREPEATABLEREAD_T2_TRUNGDUC
	@id_agency nchar(10),
	@id_dish nchar(10),
	@unit int
AS
BEGIN TRAN
	UPDATE MENU
	SET unit = unit - @unit
	WHERE id_agency = @id_agency and isActive = 1 and id_dish = @id_dish
COMMIT TRAN
GO


GO
--TRANSACTION 1 FIX--
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T1_TRUNGDUC', N'P') IS NOT NULL DROP PROC PROC_UNREPEATABLEREAD_T1_TRUNGDUC
GO
CREATE PROC PROC_UNREPEATABLEREAD_T1_TRUNGDUC
	@id_agency nchar(10)
AS
BEGIN TRAN
SET TRAN ISOLATION LEVEL REPEATABLE READ

	SELECT M.id_agency, D.id_dish, M.unit, D.dish_name, D.type_dish, D.image, D.price
	FROM MENU M JOIN DISH D 
	ON id_agency = @id_agency AND M.id_dish = D.id_dish AND M.isActive = 1 AND M.unit >= 1

	WAITFOR DELAY '00:00:15'

	SELECT M.id_agency, D.id_dish, M.unit, D.dish_name, D.type_dish, D.image, D.price
	FROM MENU M JOIN DISH D 
	ON id_agency = @id_agency AND M.id_dish = D.id_dish AND M.isActive = 1 AND M.unit >=1
	
COMMIT TRAN
GO



--T1
EXEC PROC_UNREPEATABLEREAD_T1_TRUNGDUC N'ag_1'

--T2
EXEC PROC_UNREPEATABLEREAD_T2_TRUNGDUC N'ag_1', N'dish_2', 26

--T1(FIXED)
EXEC PROC_UNREPEATABLEREAD_T1_TRUNGDUC N'ag_1'