USE HuongVietRestaurant
GO
--===============> TEST CASE 07 <==============

/*
- TestCase07: 
- Tình huống: Quản lý A cập nhật tình trạng đơn hàng của đơn hàng D nhưng chưa commit 
thì người quản lý B cũng cập nhật tình tình trạng đơn hàng của  đơn hàng D. (2 quản lý cùng thuộc 1 chi nhánh)
- Hướng dẫn sử dụng: 
	+ Bước 1: Chạy TRANSACTION T1 
	+ Bước 2: Trong vòng 15 giây kể từ khi chạy TRANSACTION T1 ta chạy TRANSACTION T2
*/
--TRANSACTION 1
IF OBJECT_ID('PROC_LOSTUPDATE_T1_LAM', N'P') IS NOT NULL DROP PROC PROC_LOSTUPDATE_T1_LAM
GO
CREATE PROC PROC_LOSTUPDATE_T1_LAM @id_bill nchar(10), @status int
AS
BEGIN
	BEGIN TRAN
		DECLARE @p int 
		SELECT @s = [status]
		FROM BILL
		WHERE id_bill = @id_bill
		SET @s = @status
		WAITFOR DELAY '00:00:15'

		UPDATE BILL 
		SET [status] = @status
		WHERE id_bill = @id_bill
	COMMIT TRAN
END

-- TRANSACTION T2
IF OBJECT_ID('PROC_LOSTUPDATE_T2_LAM', N'P') IS NOT NULL DROP PROC PROC_LOSTUPDATE_T2_LAM
GO
CREATE PROC PROC_LOSTUPDATE_T2_LAM @id_bill nchar(10), @status int
AS
BEGIN
	BEGIN TRAN
		DECLARE @p int 
		SELECT @s = [status]
		FROM BILL
		WHERE id_bill = @id_bill
		SET @s = @status

		UPDATE BILL 
		SET [status] = @status
		WHERE id_bill = @id_bill
	COMMIT TRAN
END

--FIX => TRANSACTION 1
IF OBJECT_ID('PROC_LOSTUPDATE_T1_LAM', N'P') IS NOT NULL DROP PROC PROC_LOSTUPDATE_T1_LAM
GO
CREATE PROC PROC_LOSTUPDATE_T1_LAM @id_bill nchar(10), @status int
AS
BEGIN
	BEGIN TRAN
		SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
		DECLARE @p int 
		SELECT @s = [status]
		FROM BILL
		WHERE id_bill = @id_bill
		SET @s = @status
		WAITFOR DELAY '00:00:15'

		UPDATE BILL 
		SET [status] = @status
		WHERE id_bill = @id_bill
	COMMIT TRAN
END



--T1(ERROR)
EXEC PROC_LOSTUPDATE_T1_LAM 'bill_1', 'sta_1'

--T2
EXEC PROC_LOSTUPDATE_T2_LAM 'bill_1', 'sta_1'

--T1(FIXED)
EXEC PROC_LOSTUPDATE_T1_LAM 'bill_1', 'sta_1'