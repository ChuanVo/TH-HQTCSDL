USE HuongVietRestaurant
GO
--===============> TEST CASE 23 <==============


-- TestCase23: 
-- Tình huống:
/*Giao tác A: 
- Quản lý 1 xem tình trạng đơn hàng của id_bill  'X' (khi này sẽ giữ khóa đọc)
- Delay 10s (Giao tác B thực hiện)
- Quản lý 1 muốn cập nhật tình trạng đơn hàng cho  id_bill  'X' nhưng không thực hiện được (chờ giao tác B nhả khóa).
Giao tác B:
- Quản lý 2 xem tình trạng đơn hàng của id_bill  'X' (khi này sẽ giữ khóa đọc)
- Delay 10s (Giao tác B thực hiện)
- Quản lý 2 muốn cập nhật tình trạng đơn hàng cho  id_bill  'X' nhưng không thực hiện được (chờ giao tác B nhả khóa). Và giao tác B cũng không nhả khóa.
=> Dẫn đến 2 tác chờ nhau và deadlock xảy ra => DMBS sẽ kill 1 giáo tác 

- Hướng dẫn sử dụng: 
	+ Bước 1: Chạy TRANSACTION T1 
	+ Bước 2: Trong vòng 15 giây kể từ khi chạy TRANSACTION T1 ta chạy TRANSACTION T2
*/
--TRANSACTION 1 -- Quản lý 1 cập nhật tình trạng đơn hàng cho  id_bill  'X' tại chi nhánh 'Y'
IF OBJECT_ID('PROC_DEADLOCK_T1_TRUNGDUC', N'P') IS NOT NULL DROP PROC PROC_DEADLOCK_T1_TRUNGDUC
GO
CREATE PROC PROC_DEADLOCK_T1_TRUNGDUC
	@id_bill nchar(10),
	@id_agency nchar(10),
	@status nchar(10)
AS
BEGIN TRAN
	SELECT * 
	FROM BILL b WITH(HOLDLOCK)
	WHERE b.id_bill = @id_bill and b.agency = @id_agency and b.isActive = 1
	WAITFOR DELAY '00:00:10'

	UPDATE BILL WITH(XLOCK)
	SET status = @status
	WHERE id_bill = @id_bill and agency = @id_agency and isActive = 1

COMMIT TRAN
GO



--TRANSACTION 2 --Quản lý 2 cập nhật tình trạng đơn hàng cho  id_bill  'X' tại chi nhánh 'Y'
IF OBJECT_ID('PROC_DEADLOCK_T2_TRUNGDUC', N'P') IS NOT NULL DROP PROC PROC_DEADLOCK_T2_TRUNGDUC
GO
CREATE PROC PROC_DEADLOCK_T2_TRUNGDUC
	@id_bill nchar(10),
	@id_agency nchar(10),
	@status nchar(10)
AS
BEGIN TRAN
	SELECT * 
	FROM BILL b WITH(HOLDLOCK)
	WHERE b.id_bill = @id_bill and b.agency = @id_agency and b.isActive = 1
	WAITFOR DELAY '00:00:10'

	UPDATE BILL WITH(XLOCK)
	SET status = @status
	WHERE id_bill = @id_bill and agency = @id_agency and isActive = 1

COMMIT TRAN
GO



--TRANSACTION 2 FIX --Quản lý 2 cập nhật tình trạng đơn hàng cho  id_bill  'X' tại chi nhánh 'Y'
IF OBJECT_ID('PROC_DEADLOCK_T2_TRUNGDUC', N'P') IS NOT NULL DROP PROC PROC_DEADLOCK_T2_TRUNGDUC
GO
CREATE PROC PROC_DEADLOCK_T2_TRUNGDUC
	@id_bill nchar(10),
	@id_agency nchar(10),
	@status nchar(10)
AS
BEGIN TRAN
	SELECT * 
	FROM BILL b WITH(NOLOCK)
	WHERE b.id_bill = @id_bill and b.agency = @id_agency and b.isActive = 1
	WAITFOR DELAY '00:00:10'

	UPDATE BILL WITH(XLOCK)
	SET status = @status
	WHERE id_bill = @id_bill and agency = @id_agency and isActive = 1

COMMIT TRAN
GO



--T1
EXEC PROC_DEADLOCK_T1_TRUNGDUC N'bill_1', N'ag_1', N'sta_4'

--T2
EXEC PROC_DEADLOCK_T2_TRUNGDUC N'bill_1', N'ag_1', N'sta_3'

--T2(FIXED)
EXEC PROC_DEADLOCK_T2_TRUNGDUC N'bill_1', N'ag_1', N'sta_3'