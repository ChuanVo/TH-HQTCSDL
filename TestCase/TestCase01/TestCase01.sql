﻿sUSE HuongVietRestaurant
GO
--===============> TEST CASE 01 <==============

/*
- TestCase01: 
- Tình huống: Xảy ra khi người quản lý cập nhật giá của món ăn nhưng chưa commit (bị rollback khi nhập sai) 
	thì người dùng vào xem thông tin món ăn
- Hướng dẫn sử dụng: 
	+ Bước 1: Chạy TRANSACTION T1 (Update giá của món ăn)
	+ Bước 2: Trong vòng 15 giây kể từ khi chạy TRANSACTION T1 ta chạy TRANSACTION T2 (xem thông tin món ăn)
*/

/*
- PROCEDURE
*/

-- PROCEDURE 1
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

		IF @price < 0
		BEGIN
			PRINT 'Rollback!'
			ROLLBACK 
		END
	COMMIT TRAN 
END

-- PROCEDURE 2
IF OBJECT_ID('PROC_DIRTYREAD_T2_F_CHUANVO', 'p') is not null DROP PROC PROC_DIRTYREAD_T2_F_CHUANVO
GO
CREATE PROC PROC_DIRTYREAD_T2_F_CHUANVO @id_dish nchar(10)
AS
BEGIN
	BEGIN TRAN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		SELECT * 
		FROM DISH 
		WHERE id_dish = @id_dish
	COMMIT TRAN
END

--FIX => PROCEDURE 2
IF OBJECT_ID('PROC_DIRTYREAD_T2_T_CHUANVO', 'p') is not null DROP PROC PROC_DIRTYREAD_T2_T_CHUANVO
GO
CREATE PROC PROC_DIRTYREAD_T2_T_CHUANVO @id_dish nchar(10)
AS
BEGIN
	BEGIN TRAN
		SELECT * 
		FROM DISH 
		WHERE id_dish = @id_dish and isActive = 1
	COMMIT TRAN
END

/*
- TRANSACTION 
*/

--T1
EXEC PROC_DIRTYREAD_T1_CHUANVO 'dish_1', '25000'

-- T2(ERROR)
EXEC PROC_DIRTYREAD_T2_F_CHUANVO 'dis_1'

--T2 (FIXED)
EXEC PROC_DIRTYREAD_T2_T_CHUANVO 'dis_1'
