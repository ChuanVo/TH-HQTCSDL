USE HuongVietRestaurant
GO
--===============> TEST CASE 02 <==============

/*
- TestCase02: 
- Tình huống: Quản lý cập nhật giá món ăn (DISH) nhưng chưa commit thì khách hàng vào xem thông tin món ăn.
- Hướng dẫn sử dụng: 
	+ Bước 1: Chạy TRANSACTION T1 
	+ Bước 2: Trong vòng 15 giây kể từ khi chạy TRANSACTION T1 ta chạy TRANSACTION T2
*/
-- TRANSACTION 1
IF OBJECT_ID('PROC_DIRTYREAD_T1_CHUANVO', 'p') is not null DROP PROC PROC_DIRTYREAD_T1_CHUANVO
GO

CREATE PROC PROC_DIRTYREAD_T1_CHUANVO @id_dish nchar(10), @price int
AS
BEGIN
	BEGIN TRAN 
		UPDATE DISH 
		SET price = @price
		WHERE id_dish = @id_dish 
		WAITFOR DELAY '00:00:15'

		IF @price <= 0
		BEGIN
			PRINT 'Rollback!'
			ROLLBACK TRAN
		END
		ELSE
		BEGIN
			COMMIT TRAN
		END
END

-- TRANSACTION 2
IF OBJECT_ID('PROC_DIRTYREAD_T2_F_CHUANVO', 'p') is not null DROP PROC PROC_DIRTYREAD_T2_F_CHUANVO
GO
CREATE PROC PROC_DIRTYREAD_T2_F_CHUANVO @id_agency nchar(10)
AS
BEGIN
	BEGIN TRAN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		SELECT M.id_agency, D.id_dish, M.unit, D.dish_name, D.type_dish, D.image, D.price
		FROM MENU M JOIN DISH D 
		ON id_agency = @id_agency AND M.id_dish = D.id_dish AND M.isActive = 1
	COMMIT TRAN
END

----FIX => TRANSACTION 2 (FIXED)
---- Handle: Use insolation level READ COMMITED to handle this error and it is default insolation level of sql server
IF OBJECT_ID('PROC_DIRTYREAD_T2_T_CHUANVO', 'p') is not null DROP PROC PROC_DIRTYREAD_T2_T_CHUANVO
GO
CREATE PROC PROC_DIRTYREAD_T2_T_CHUANVO @id_agency nchar(10)
AS
BEGIN
	BEGIN TRAN
		SELECT M.id_agency, D.id_dish, M.unit, D.dish_name, D.type_dish, D.image, D.price
		FROM MENU M JOIN DISH D 
		ON id_agency = @id_agency AND M.id_dish = D.id_dish AND M.isActive = 1
	COMMIT TRAN
END

--T1
EXEC PROC_DIRTYREAD_T1_CHUANVO 'dish_1', 12000

-- T2(ERROR)
EXEC PROC_DIRTYREAD_T2_F_CHUANVO 'ag_1'

--T2 (FIXED)
EXEC PROC_DIRTYREAD_T2_T_CHUANVO 'ag_1'
