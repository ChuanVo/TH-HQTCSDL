﻿USE HuongVietRestaurant
GO

--============> DEADLOCK <==========

--ChuanVo

--Lang

--ADMIN A đang xem  thông tin món bún bò tại chi nhánh 1 -> cập nhật số lượng món bún bò tại chi nhánh 1(chưa commit) delay 5s
--ADMIN B cũng xem  thông tin món bún bò tại chi nhánh 1 -> cập nhật số lượng món bún bò tại chi nhánh 1(commit)

--TRANSACTION 1 --
IF OBJECT_ID('PROC_DEADLOCK_T1_LANG', N'P') IS NOT NULL DROP PROC PROC_DEADLOCK_T1_LANG
GO
CREATE PROC PROC_DEADLOCK_T1_LANG
	@id_dish nchar(10),
	@id_agency nchar(10),
	@unit int
AS
BEGIN TRAN
	SELECT * 
	FROM MENU m WITH(HOLDLOCK)
	WHERE m.id_dish = @id_dish and m.id_agency = @id_agency and m.isActive = 1
	WAITFOR DELAY '00:00:10'

	UPDATE MENU WITH(XLOCK)
	SET unit = @unit
	WHERE id_dish = @id_dish and id_agency = @id_agency and isActive = 1
	
COMMIT TRAN

EXEC PROC_DEADLOCK_T1_LANG 'dish_1', 'ag_1', 11


--TRANSACTION 2 --
IF OBJECT_ID('PROC_DEADLOCK_T2_LANG', N'P') IS NOT NULL DROP PROC PROC_DEADLOCK_T2_LANG
GO
CREATE PROC PROC_DEADLOCK_T2_LANG
	@id_dish nchar(10),
	@id_agency nchar(10),
	@unit int
AS
BEGIN TRAN
	
	SELECT *
	FROM MENU m WITH(HOLDLOCK)
	WHERE m.id_dish = @id_dish and m.id_agency = @id_agency and m.isActive = 1 
	WAITFOR DELAY '00:00:10'

	UPDATE MENU WITH (XLOCK)
	SET unit = @unit
	WHERE id_dish = @id_dish and id_agency = @id_agency and isActive = 1
	
COMMIT TRAN
GO

EXEC PROC_DEADLOCK_T2_LANG 'dish_1', 'ag_1', 232
--TRANSACTION 2 FIX--
IF OBJECT_ID('PROC_DEADLOCK_T2_LANG', N'P') IS NOT NULL DROP PROC PROC_DEADLOCK_T2_LANG
GO
CREATE PROC PROC_DEADLOCK_T2_LANG
	@id_dish nchar(10),
	@id_agency nchar(10),
	@unit int
AS
BEGIN TRAN
	
	SELECT *
	FROM MENU m WITH(NOLOCK)
	WHERE m.id_dish = @id_dish and m.id_agency = @id_agency and m.isActive = 1 
	WAITFOR DELAY '00:00:10'

	UPDATE MENU WITH (XLOCK)
	SET unit = @unit
	WHERE id_dish = @id_dish and id_agency = @id_agency and isActive = 1
	
COMMIT TRAN

EXEC PROC_DEADLOCK_T2_LANG 'dish_1', 'ag_1', 232

--AnHoa


--TrungDuc

/*Giao tác A: 
- Quản lý 1 xem tình trạng đơn hàng của id_bill  'X' (khi này sẽ giữ khóa đọc)
- Delay 10s (Giao tác B thực hiện)
- Quản lý 1 muốn cập nhật tình trạng đơn hàng cho  id_bill  'X' nhưng không thực hiện được (chờ giao tác B nhả khóa).
Giao tác B:
- Quản lý 2 xem tình trạng đơn hàng của id_bill  'X' (khi này sẽ giữ khóa đọc)
- Delay 10s (Giao tác B thực hiện)
- Quản lý 2 muốn cập nhật tình trạng đơn hàng cho  id_bill  'X' nhưng không thực hiện được (chờ giao tác B nhả khóa). Và giao tác B cũng không nhả khóa.
=> Dẫn đến 2 tác chờ nhau và deadlock xảy ra => DMBS sẽ kill 1 giáo tác */

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

EXEC PROC_DEADLOCK_T1_TRUNGDUC N'bill_1', N'ag_1', N'sta_4'

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

EXEC PROC_DEADLOCK_T2_TRUNGDUC N'bill_1', N'ag_1', N'sta_3'

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

EXEC PROC_DEADLOCK_T2_TRUNGDUC N'bill_1', N'ag_1', N'sta_3'
--DangLam

