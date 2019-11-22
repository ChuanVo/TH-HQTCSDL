USE [HuongVietRestaurant]
GO

--============> LOST UPDATE <==========

--AnHoa

--Mô tả: Khách hàng A đang xem thông tin món X, thì khách hàng B cũng xem thông tin món X rồi đặt mua làm số lượng món giảm, khách hàng A đặt mua món X làm số lượng món giảm.

--TRANSACTION 1:
IF OBJECT_ID('PROC_LOSTUPDATE_T1_ANHOA', 'p') is not null DROP PROC PROC_LOSTUPDATE_T1_ANHOA
GO
CREATE PROC PROC_LOSTUPDATE_T1_ANHOA @id_agency nchar(10), @id_dish nchar(10), @unit int
AS
BEGIN TRAN
DECLARE @unit0 int
SET @unit0 = 0
	SELECT D.dish_name, A.agency_name, T.type_dish_name, D.price, M.unit
	FROM AGENCY A, MENU M, DISH D, TYPE_DISH T
	WHERE A.id_agency = @id_agency AND A.id_agency = M.id_agency AND M.id_dish = D.id_dish AND D.type_dish = T.id_type_dish AND D.id_dish = @id_dish	
	SELECT @unit0 = M.unit
	FROM MENU M
	WHERE M.id_agency = @id_agency AND M.id_dish = @id_dish

	WAITFOR DELAY '00:00:15'
	SET @unit0 = @unit0 - @unit
	UPDATE MENU
	SET unit = @unit0
	WHERE id_agency = @id_agency AND id_dish = @id_dish
COMMIT TRAN

EXEC PROC_LOSTUPDATE_T1_ANHOA 'ag_1', 'dish_1', 1

--TRANSACTION 2:
IF OBJECT_ID('PROC_LOSTUPDATE_T2_ANHOA', 'p') is not null DROP PROC PROC_LOSTUPDATE_T2_ANHOA
GO
CREATE PROC PROC_LOSTUPDATE_T2_ANHOA @id_agency nchar(10), @id_dish nchar(10), @unit int
AS
BEGIN TRAN
DECLARE @unit0 int
SET @unit0 = 0
	SELECT D.dish_name, A.agency_name, T.type_dish_name, D.price, M.unit
	FROM AGENCY A, MENU M, DISH D, TYPE_DISH T
	WHERE A.id_agency = @id_agency AND A.id_agency = M.id_agency AND M.id_dish = D.id_dish AND D.type_dish = T.id_type_dish AND D.id_dish = @id_dish	
	SELECT @unit0 = M.unit
	FROM MENU M
	WHERE M.id_agency = @id_agency AND M.id_dish = @id_dish

	SET @unit0 = @unit0 - @unit
	UPDATE MENU
	SET unit = @unit0
	WHERE id_agency = @id_agency AND id_dish = @id_dish	
COMMIT TRAN

EXEC PROC_LOSTUPDATE_T2_ANHOA 'ag_1', 'dish_1', 2

--FIX TRANSACTION T1:
IF OBJECT_ID('PROC_LOSTUPDATE_T1_ANHOA', 'p') is not null DROP PROC PROC_LOSTUPDATE_T1_ANHOA
GO
CREATE PROC PROC_LOSTUPDATE_T1_ANHOA @id_agency nchar(10), @id_dish nchar(10), @unit int
AS
BEGIN TRAN
SET TRAN ISOLATION LEVEL REPEATABLE READ
DECLARE @unit0 int
SET @unit0 = 0
	SELECT D.dish_name, A.agency_name, T.type_dish_name, D.price, M.unit
	FROM AGENCY A, MENU M, DISH D, TYPE_DISH T
	WHERE A.id_agency = @id_agency AND A.id_agency = M.id_agency AND M.id_dish = D.id_dish AND D.type_dish = T.id_type_dish AND D.id_dish = @id_dish	
	SELECT @unit0 = M.unit
	FROM MENU M
	WHERE M.id_agency = @id_agency AND M.id_dish = @id_dish

	WAITFOR DELAY '00:00:15'
	SET @unit0 = @unit0 - @unit
	UPDATE MENU
	SET unit = @unit0
	WHERE id_agency = @id_agency AND id_dish = @id_dish
COMMIT TRAN

EXEC PROC_LOSTUPDATE_T1_ANHOA 'ag_1', 'dish_1', 1