USE HuongVietRestaurant
GO
--===============> TEST CASE 06 <==============

/*
- TestCase06: 
- Tình huống: Quản lý A cập nhật giá của món ăn, và quản lý B cũng cập nhật giá của món ăn.
- Hướng dẫn sử dụng: 
	+ Bước 1: Chạy TRANSACTION T1 
	+ Bước 2: Trong vòng 15 giây kể từ khi chạy TRANSACTION T1 ta chạy TRANSACTION T2
*/
--TRANSACTION 1
IF OBJECT_ID('PROC_LOSTUPDATE_T1_CHUANVO', N'P') IS NOT NULL DROP PROC PROC_LOSTUPDATE_T1_CHUANVO
GO
CREATE PROC PROC_LOSTUPDATE_T1_CHUANVO @id_dish nchar(10), @price int
AS
BEGIN
	BEGIN TRAN
		DECLARE @p int 
		SELECT @p = price
		FROM DISH
		WHERE id_dish = @id_dish
		SET @p = @price
		WAITFOR DELAY '00:00:15'

		UPDATE DISH
		SET price = @price
		WHERE id_dish = @id_dish
	COMMIT TRAN
END

-- TRANSACTION T2
IF OBJECT_ID('PROC_LOSTUPDATE_T2_CHUANVO', N'P') IS NOT NULL DROP PROC PROC_LOSTUPDATE_T2_CHUANVO
GO
CREATE PROC PROC_LOSTUPDATE_T2_CHUANVO @id_dish nchar(10), @price int
AS
BEGIN
	BEGIN TRAN
		DECLARE @p int 
		SELECT @p = price
		FROM DISH
		WHERE id_dish = @id_dish
		SET @p = @price

		UPDATE DISH
		SET price = @price
		WHERE id_dish = @id_dish
	COMMIT TRAN
END

--FIX => TRANSACTION 1
IF OBJECT_ID('PROC_LOSTUPDATE_T1_CHUANVO', N'P') IS NOT NULL DROP PROC PROC_LOSTUPDATE_T1_CHUANVO
GO
CREATE PROC PROC_LOSTUPDATE_T1_CHUANVO @id_dish nchar(10), @price int
AS
BEGIN
	BEGIN TRAN
		SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
		DECLARE @p int 
		SELECT @p = price
		FROM DISH
		WHERE id_dish = @id_dish
		SET @p = @price
		WAITFOR DELAY '00:00:15'

		UPDATE DISH
		SET price = @price
		WHERE id_dish = @id_dish
	COMMIT TRAN
END


--T1(ERROR)
EXEC PROC_LOSTUPDATE_T1_CHUANVO 'dish_1', 12000

--T2
EXEC PROC_LOSTUPDATE_T2_CHUANVO 'dish_1', 10000

--T1(FIXED)
EXEC PROC_LOSTUPDATE_T1_CHUANVO 'dish_1', 12000