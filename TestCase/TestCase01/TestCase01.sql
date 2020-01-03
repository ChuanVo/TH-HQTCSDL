USE HuongVietRestaurant
GO
--===============> TEST CASE 01 <==============

/*
- TestCase01: 
- Tình huống: Quản lý cửa hàng cập nhật tên cho nhân viên cấp dưới (chưa commit) 
thì nhân viên khác vào xem thông tin của nhân viên được cập nhật
- Hướng dẫn sử dụng: 
	+ Bước 1: Chạy TRANSACTION T1 (Update tên nhân viên)
	+ Bước 2: Trong vòng 10 giây kể từ khi chạy TRANSACTION T1 ta chạy TRANSACTION T2 (xem thông tin nhân viên)
*/
-- T1: Quản lý cập nhât tên nhân viên 
IF OBJECT_ID('PROC_DIRTYREAD_T1_TRUNGDUC', 'p') IS NOT NULL DROP PROC PROC_DIRTYREAD_T1_TRUNGDUC
GO
CREATE PROC PROC_DIRTYREAD_T1_TRUNGDUC @id_employee nchar(10), @name nchar(50)
AS
BEGIN TRAN
		UPDATE EMPLOYEE
		SET name = @name
		WHERE id_employee = @id_employee
		WAITFOR DELAY '00:00:10'
		IF @name = ''
		BEGIN
			PRINT 'Rollback!'
			ROLLBACK TRAN
		END
		ELSE
		BEGIN
			COMMIT TRAN
		END


-- T2: quản lý khác vào xem thông tin nhân viên.
IF OBJECT_ID('PROC_DIRTYREAD_T2_TRUNGDUC', 'p') IS NOT NULL
DROP PROC PROC_DIRTYREAD_T2_TRUNGDUC
GO
CREATE PROC PROC_DIRTYREAD_T2_TRUNGDUC @id_employee nchar(10)
AS
BEGIN TRAN
		SET TRAN ISOLATION LEVEL READ UNCOMMITTED  
		SELECT *
		FROM EMPLOYEE
		WHERE id_employee = @id_employee
COMMIT TRAN




-- T2 FIX: quản lý khác vào xem thông tin nhân viên.
IF OBJECT_ID('PROC_DIRTYREAD_T2_TRUNGDUC', 'p') IS NOT NULL
DROP PROC PROC_DIRTYREAD_T2_TRUNGDUC
GO
CREATE PROC PROC_DIRTYREAD_T2_TRUNGDUC @id_employee nchar(10)
AS
BEGIN TRAN
		SET TRAN ISOLATION LEVEL READ COMMITTED  
		SELECT *
		FROM EMPLOYEE
		WHERE id_employee = @id_employee
COMMIT TRAN




--T1
EXEC PROC_DIRTYREAD_T1_TRUNGDUC 'em_1', ''

-- T2(ERROR)
EXEC PROC_DIRTYREAD_T2_TRUNGDUC 'em_1'

--T2 (FIXED)
EXEC PROC_DIRTYREAD_T2_TRUNGDUC 'em_1'
