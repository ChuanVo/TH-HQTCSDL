--Dirty read--
--ChuanVo
--Quản lý cập nhật giá món ăn (DISH) nhưng chưa commit thì khách hàng vào xem thông tin món ăn.

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

--FIX => TRANSACTION 2 (FIXED)
-- Handle: Use insolation level READ COMMITED to handle this error and it is default insolation level of sql server
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

--Lang
--Quản lý cập nhật hình ảnh món ăn (DISH) nhưng chưa commit thì khách hàng vào xem thông tin món ăn.
--TRANSACTION 1--
IF OBJECT_ID('PROC_DIRTYREAD_T1_LANG', N'P') IS NOT NULL DROP PROC PROC_DIRTYREAD_T1_LANG
GO
CREATE PROC PROC_DIRTYREAD_T1_LANG
	@id_dish nchar(10),
	@image nchar(50)
AS
BEGIN TRAN
	UPDATE DISH
	SET image = @image
	WHERE id_dish = @id_dish
	WAITFOR DELAY '00:00:10'
	IF @image = ''
	BEGIN
		PRINT 'Rollback!'
		ROLLBACK TRAN
	END
	ELSE
	BEGIN
		COMMIT TRAN
	END
GO

EXEC PROC_DIRTYREAD_T1_LANG 'dish_5', ''

--TRANSACTION 2 --
IF OBJECT_ID('PROC_DIRTYREAD_T2_LANG', N'P') IS NOT NULL DROP PROC PROC_DIRTYREAD_T2_LANG
GO
CREATE PROC PROC_DIRTYREAD_T2_LANG
	@id_dish nchar(10)
AS
BEGIN TRAN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SELECT *
	FROM DISH 
	WHERE id_dish = @id_dish
COMMIT TRAN
GO

EXEC PROC_DIRTYREAD_T2_LANG 'dish_5'

-- TRANSACTION 2 FIX --
IF OBJECT_ID('PROC_DIRTYREAD_T2_LANG', N'P') IS NOT NULL DROP PROC PROC_DIRTYREAD_T2_LANG
GO
CREATE PROC PROC_DIRTYREAD_T2_LANG
	@id_dish nchar(10)
AS
BEGIN TRAN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	SELECT *
	FROM DISH with (RepeatableRead)
	WHERE id_dish = @id_dish
COMMIT TRAN
GO

EXEC PROC_DIRTYREAD_T2_LANG 'dish_5'



--Lam
--Quản lý cập nhât gmail nhân viên nhưng chưa commit 
--thì quản lý khác vào xem thông tin nhân viên.
-- T1: Quản lý cập nhât tên nhân viên 
IF OBJECT_ID('PROC_DIRTYREAD_T1_LAM', 'p') IS NOT NULL DROP PROC PROC_DIRTYREAD_T1_LAM
GO
CREATE PROC PROC_DIRTYREAD_T1_LAM @id_employee nchar(10), @gmail nchar(50)
AS
BEGIN TRAN
		UPDATE EMPLOYEE
		SET gmail = @gmail
		WHERE id_employee = @id_employee
		WAITFOR DELAY '00:00:10'
		IF @gmail = ''
		BEGIN
			PRINT 'Rollback!'
			ROLLBACK TRAN
		END
		ELSE
		BEGIN
			COMMIT TRAN
		END

EXEC PROC_DIRTYREAD_T1_LAM 'em_1', ''

-- T2: quản lý khác vào xem thông tin nhân viên.
IF OBJECT_ID('PROC_DIRTYREAD_T2_LAM', 'p') IS NOT NULL
DROP PROC PROC_DIRTYREAD_T2_LAM
GO
CREATE PROC PROC_DIRTYREAD_T2_LAM @id_employee nchar(10)
AS
BEGIN TRAN
		SET TRAN ISOLATION LEVEL READ UNCOMMITTED  
		SELECT *
		FROM EMPLOYEE
		WHERE id_employee = @id_employee
COMMIT TRAN


EXEC PROC_DIRTYREAD_T2_LAM 'em_1'

-- T2 FIX: quản lý khác vào xem thông tin nhân viên.
IF OBJECT_ID('PROC_DIRTYREAD_T2_LAM', 'p') IS NOT NULL
DROP PROC PROC_DIRTYREAD_T2_LAM
GO
CREATE PROC PROC_DIRTYREAD_T2_LAM @id_employee nchar(10)
AS
BEGIN TRAN
		SET TRAN ISOLATION LEVEL READ COMMITTED  
		SELECT *
		FROM EMPLOYEE
		WHERE id_employee = @id_employee
COMMIT TRAN


EXEC PROC_DIRTYREAD_T2_LAM 'em_1'


--AnHoa
--Mô tả: Quản lý cập nhật số lượng của món ăn A trong MENU (chưa commit) thì khách hàng thực hiện xem MENU có chứa món ăn mà quản lý đang cập nhật.

--TRANSACTION 1:
IF OBJECT_ID('PROC_DIRTYREAD_T1_ANHOA', 'p') is not null DROP PROC PROC_DIRTYREAD_T1_ANHOA
GO
CREATE PROC PROC_DIRTYREAD_T1_ANHOA @id_agency nchar(10), @id_dish nchar(10), @unit int
AS
BEGIN TRAN
	UPDATE MENU
	SET unit = @unit
	WHERE id_agency = @id_agency AND id_dish = @id_dish
	WAITFOR DELAY '00:00:15'
	IF (@unit < 0)
	BEGIN
		ROLLBACK TRAN
	END
	ELSE
	BEGIN
		COMMIT TRAN
	END

EXEC PROC_DIRTYREAD_T1_ANHOA 'ag_1', 'dish_1', -1

--TRANSACTION 2:
IF OBJECT_ID('PROC_DIRTYREAD_T2_ANHOA', 'p') is not null DROP PROC PROC_DIRTYREAD_T2_ANHOA
GO
CREATE PROC PROC_DIRTYREAD_T2_ANHOA @id_agency nchar(10)
AS
BEGIN TRAN
SET TRAN ISOLATION LEVEL READ UNCOMMITTED  --Đảm bảo cho việc xảy ra DirtyRead
	SELECT *
	FROM MENU
	WHERE id_agency = @id_agency
COMMIT TRAN

EXEC PROC_DIRTYREAD_T2_ANHOA 'ag_1'

--TRANSACTION 2 FIX:
IF OBJECT_ID('PROC_DIRTYREAD_T2_ANHOA', 'p') is not null DROP PROC PROC_DIRTYREAD_T2_ANHOA
GO
CREATE PROC PROC_DIRTYREAD_T2_ANHOA @id_agency nchar(10)
AS
BEGIN TRAN
SET TRAN ISOLATION LEVEL READ COMMITTED  --Giải quyết lỗi DirtyRead
	SELECT *
	FROM MENU
	WHERE id_agency = @id_agency
COMMIT TRAN
EXEC PROC_DIRTYREAD_T2_ANHOA 'ag_1'

USE HuongVietRestaurant
GO

--TRUNGDUC
-- Mô tả: Quản lý cửa hàng cập nhật tên nhân viên (chưa commit) thì nhân viên khác vào xem thông tin của nhân viên được cập nhật

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
EXEC PROC_DIRTYREAD_T1_TRUNGDUC 'em_1', ''

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


EXEC PROC_DIRTYREAD_T2_TRUNGDUC 'em_1'

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


EXEC PROC_DIRTYREAD_T2_TRUNGDUC 'em_1'


--Lost update--
--ChuanVo
--Quản lý A cập nhật giá của món ăn, và quản lý B cũng cập nhật giá của món ăn.
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


--Lang
--Admin nhà hàng đang cập nhật số lượng món Phở bò tại chi nhánh 1 giảm đi @unit (số lượng) (chưa commit), 
--trong khi đó Admin A tại chi nhánh 1 bấm  "Thanh toán" 1 hóa đơn có món Phở bò (update số lượng món phở tại chi nhánh 1). 
--TRANSACTION 1--
IF OBJECT_ID('PROC_LOSTUPDATE_T1_LANG', N'P') IS NOT NULL DROP PROC PROC_LOSTUPDATE_T1_LANG
GO
CREATE PROC PROC_LOSTUPDATE_T1_LANG
	@id_dish nchar(10),
	@unit int,
	@id_agency nchar(10)
AS
BEGIN TRAN
	DECLARE @unitnew int

	SELECT @unitnew = unit
	FROM MENU
	WHERE id_dish = @id_dish and id_agency = @id_agency
	WAITFOR DELAY '00:00:10'
	SET @unitnew =  @unit
	
	UPDATE MENU 
	SET unit = @unitnew
	WHERE id_dish = @id_dish and id_agency = @id_agency 
COMMIT TRAN

EXEC PROC_LOSTUPDATE_T1_LANG 'dish_4', 50, 'ag_2'

--TRANSACTION 2--
IF OBJECT_ID('PROC_LOSTUPDATE_T2_LANG', N'P') IS NOT NULL DROP PROC PROC_LOSTUPDATE_T2_LANG
GO
CREATE PROC PROC_LOSTUPDATE_T2_LANG
	@id_dish nchar(10),
	@unit int,
	@id_agency nchar(10)
AS
BEGIN TRAN
	DECLARE @unitnew int

	SELECT @unitnew = unit
	FROM MENU
	WHERE id_dish = @id_dish and id_agency = @id_agency 
	SET @unitnew = @unitnew - @unit
	
	UPDATE MENU 
	SET unit = @unitnew
	WHERE id_dish = @id_dish and id_agency = @id_agency 
COMMIT TRAN

EXEC PROC_LOSTUPDATE_T2_LANG 'dish_4', 2, 'ag_2'

--TRANSACTION 1--
IF OBJECT_ID('PROC_LOSTUPDATE_T1_LANG', N'P') IS NOT NULL DROP PROC PROC_LOSTUPDATE_T1_LANG
GO
CREATE PROC PROC_LOSTUPDATE_T1_LANG
	@id_dish nchar(10),
	@unit int,
	@id_agency nchar(10)
AS
BEGIN TRAN
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
	DECLARE @unitnew int

	SELECT @unitnew = unit
	FROM MENU
	WHERE id_dish = @id_dish and id_agency = @id_agency
	WAITFOR DELAY '00:00:10'
	SET @unitnew =  @unit
	
	UPDATE MENU 
	SET unit = @unitnew
	WHERE id_dish = @id_dish and id_agency = @id_agency 
COMMIT TRAN

EXEC PROC_LOSTUPDATE_T1_LANG 'dish_4', 50, 'ag_2'

--Lam
--Quản lý A cập nhật tình trạng đơn hàng của đơn hàng D nhưng chưa commit thì người quản lý B cũng cập nhật tình 
-- tình trạng đơn hàng của  đơn hàng D. (2 quản lý cùng thuộc 1 chi nhánh)
--TRANSACTION 1
IF OBJECT_ID('PROC_LOSTUPDATE_T1_LAM', N'P') IS NOT NULL DROP PROC PROC_LOSTUPDATE_T1_LAM
GO
CREATE PROC PROC_LOSTUPDATE_T1_LAM 
@id_bill nchar(10), @agency nchar(10), @status nchar(10)
AS
	BEGIN TRAN
		DECLARE @p nchar(10) 
		SELECT @p = [status]
		FROM BILL
		WHERE id_bill = @id_bill and agency = @agency
		WAITFOR DELAY '00:00:10'
		SET @p = @status

		UPDATE BILL 
		SET [status] = @p
		WHERE id_bill = @id_bill and agency = @agency
	COMMIT TRAN
EXEC PROC_LOSTUPDATE_T1_LAM 'bill_3', 'ag_1', 'sta_2'

-- TRANSACTION T2
IF OBJECT_ID('PROC_LOSTUPDATE_T2_LAM', N'P') IS NOT NULL DROP PROC PROC_LOSTUPDATE_T2_LAM
GO
CREATE PROC PROC_LOSTUPDATE_T2_LAM 
@id_bill nchar(10),@agency nchar(10), @status nchar(10)
AS
	BEGIN TRAN
		DECLARE @p1 nchar(10) 
		SELECT @p1 = [status]
		FROM BILL
		WHERE id_bill = @id_bill and agency = @agency
		SET @p1 = @status

		UPDATE BILL 
		SET [status] = @p1
		WHERE id_bill = @id_bill and agency = @agency
	COMMIT TRAN

EXEC PROC_LOSTUPDATE_T2_LAM 'bill_3', 'ag_1', 'sta_3'


--TRANSACTION 1 FIX
IF OBJECT_ID('PROC_LOSTUPDATE_T1_LAM', N'P') IS NOT NULL DROP PROC PROC_LOSTUPDATE_T1_LAM
GO
CREATE PROC PROC_LOSTUPDATE_T1_LAM @id_bill nchar(10), @agency nchar(10), @status nchar(10)
AS
BEGIN
	BEGIN TRAN
		SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
		DECLARE @p nchar(10) 
		SELECT @p = [status]
		FROM BILL
		WHERE id_bill = @id_bill and agency = @agency
		SET @p = @status
		WAITFOR DELAY '00:00:10'

		UPDATE BILL 
		SET [status] = @p
		WHERE id_bill = @id_bill and agency = @agency
	COMMIT TRAN
END
EXEC PROC_LOSTUPDATE_T1_LAM 'bill_3', 'ag_1', 'sta_2'

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
	SELECT @unit0 = M.unit
	FROM MENU M
	WHERE M.id_agency = @id_agency AND M.id_dish = @id_dish

	WAITFOR DELAY '00:00:15'
	SET @unit0 = @unit0 - @unit
	UPDATE MENU
	SET unit = @unit0
	WHERE id_agency = @id_agency AND id_dish = @id_dish
COMMIT TRAN

--TRUNG DUC
--Admin 1 đang thực hiện update tên của món ăn dish_1 trong bảng món ăn(chưa commit),
-- thì Admin 2 update  món ăn dish_1 trong bảng DISH 
--T1: Admin thực hiện update loại món ăn
IF OBJECT_ID('PROC_LOSTUPDATE_T1_TRUNGDUC', 'p') is not null DROP PROC PROC_LOSTUPDATE_T1_TRUNGDUC
GO
CREATE PROC PROC_LOSTUPDATE_T1_TRUNGDUC
	@id_dish nchar(10),
	@name nchar(50)
AS
BEGIN TRAN
	DECLARE @newname nchar(50)
	SELECT @newname = d.dish_name
	FROM DISH d 
	WHERE d.id_dish = @id_dish and isActive = 1
	WAITFOR DELAY '00:00:10'
	SET @newname = @name
	
	UPDATE DISH 
	SET dish_name = @name
	WHERE id_dish = @id_dish and isActive = 1
COMMIT TRAN
GO
EXEC PROC_LOSTUPDATE_T1_TRUNGDUC 'dish_1', N'Bún mắm Thái Lan'

--T2: Admin 2 update món ăn dish_1 trong bảng DISH 
IF OBJECT_ID('PROC_LOSTUPDATE_T2_TRUNGDUC', 'p') is not null DROP PROC PROC_LOSTUPDATE_T2_TRUNGDUC
GO
CREATE PROC PROC_LOSTUPDATE_T2_TRUNGDUC
	@id_dish nchar(10),
	@name nchar(50)
AS
BEGIN TRAN
	UPDATE DISH 
	SET dish_name = @name
	WHERE id_dish = @id_dish and isActive = 1
COMMIT TRAN
GO
EXEC PROC_LOSTUPDATE_T2_TRUNGDUC 'dish_1', N'Bún mộc Hà Nội'

--T1 FIX: Admin thực hiện update loại món ăn
IF OBJECT_ID('PROC_LOSTUPDATE_T1_TRUNGDUC', 'p') is not null DROP PROC PROC_LOSTUPDATE_T1_TRUNGDUC
GO
CREATE PROC PROC_LOSTUPDATE_T1_TRUNGDUC
	@id_dish nchar(10),
	@name nchar(50)
AS
BEGIN TRAN
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
	DECLARE @newname nchar(50)
	SELECT @newname = d.dish_name
	FROM DISH d 
	WHERE d.id_dish = @id_dish and isActive = 1
	WAITFOR DELAY '00:00:10'
	SET @newname = @name
	
	UPDATE DISH 
	SET dish_name = @name
	WHERE id_dish = @id_dish and isActive = 1
COMMIT TRAN
GO
EXEC PROC_LOSTUPDATE_T1_TRUNGDUC 'dish_1', N'Bún mắm Thái Lan'

--Phantom--
--ChuanVo
--Trong khi Khách hàng xem danh sách món ăn thì người quản lí chèn thêm món ăn.
--TRANSACTION 1--
IF OBJECT_ID('PROC_PHANTOM_T1_CHUANVO', 'P') IS NOT NULL DROP PROC PROC_PHANTOM_T1_CHUANVO
GO
CREATE PROC PROC_PHANTOM_T1_CHUANVO
AS
BEGIN TRAN
	SELECT * 
	FROM DISH with (RepeatableRead) 
	WHERE isActive = 1
	WAITFOR DELAY '00:00:15'
COMMIT TRAN

EXEC PROC_PHANTOM_T1_CHUANVO

--TRANSACTION 2
IF OBJECT_ID('PROC_PHANTOM_T2_CHUANVO', N'P') IS NOT NULL DROP PROC PROC_PHANTOM_T2_CHUANVO
GO
CREATE PROC PROC_PHANTOM_T2_CHUANVO
	@id_dish nchar(10),
	@id_type nchar(10),
	@dish_name nvarchar(50),
	@price int,
	@image nvarchar(10),
	@isActive int
AS
BEGIN TRAN
	INSERT [dbo].[DISH] ([id_dish], [type_dish], [dish_name], [price], [image], [isActive]) 
	VALUES (@id_dish, @id_type, @dish_name, @price, @image, @isActive)	
COMMIT TRAN

--FIX => TRANSACTION 1--
IF OBJECT_ID('PROC_PHANTOM_T1_CHUANVO', 'P') IS NOT NULL DROP PROC PROC_PHANTOM_T1_CHUANVO
GO
CREATE PROC PROC_PHANTOM_T1_CHUANVO
AS
BEGIN TRAN
	SELECT * 
	FROM DISH with (Serializable) 
	WHERE isActive = 1
	WAITFOR DELAY '00:00:15'
COMMIT TRAN


--Lang

--Quản lý A đang xem danh sách loại món ăn theo loai mon an 1 B thêm loại món ăn mới thuoc loai mon an 1
  --TRANSACTION 1--
IF OBJECT_ID('PROC_PHANTOM_T1_LANG', N'P') IS NOT NULL DROP PROC PROC_PHANTOM_T1_LANG
GO
CREATE PROC PROC_PHANTOM_T1_LANG
	@id_type nchar(10)
AS
BEGIN TRAN
	SELECT Count(*) 
	FROM DISH 
	WHERE type_dish = @id_type and isActive = 1
	WAITFOR DELAY '00:00:15'
COMMIT TRAN
GO

EXEC PROC_PHANTOM_T1_LANG N'td_1'
  --TRANSACTION 2--
IF OBJECT_ID('PROC_PHANTOM_T2_LANG', N'P') IS NOT NULL DROP PROC PROC_PHANTOM_T2_LANG
GO
CREATE PROC PROC_PHANTOM_T2_LANG
	@id_dish nchar(10),
	@id_type nchar(10),
	@dish_name nchar(50),
	@price int,
	@image nchar(10),
	@isActive int
AS
BEGIN TRAN
	INSERT [dbo].[DISH] ([id_dish], [type_dish], [dish_name], [price], [image], [isActive]) 
	VALUES (@id_dish, @id_type, @dish_name, @price, @image, @isActive)	
COMMIT TRAN
GO

EXEC PROC_PHANTOM_T2_LANG N'dish_11    ', N'td_1      ', N'Bún mọc Hà Nội', 42000, N'./', 1
--TRANSACTION 1 FIX--
IF OBJECT_ID('PROC_PHANTOM_T1_LANG', N'P') IS NOT NULL DROP PROC PROC_PHANTOM_T1_LANG
GO
CREATE PROC PROC_PHANTOM_T1_LANG
	@id_type nchar(10)
AS
BEGIN TRAN
	SELECT Count(*) 
	FROM DISH WITH (Serializable)
	WHERE type_dish = @id_type
	WAITFOR DELAY '00:00:15'
COMMIT TRAN
GO

EXEC PROC_PHANTOM_T1_LANG N'td_1'


--Lam
--Trong khi người quản lý xem danh sách nhân viên (chưa xong) thì người quản lý khác thêm nhân viên mới vào nhà hàng.
--TRANSACTION 1--
IF OBJECT_ID('PROC_PHANTOM_T1_LAM', 'P') IS NOT NULL DROP PROC PROC_PHANTOM_T1_LAM
GO
CREATE PROC PROC_PHANTOM_T1_LAM
AS
BEGIN TRAN
	SELECT * 
	FROM EMPLOYEE E, ADDRESS A
	WHERE E.isActive = '1' AND E.address = A.id_address
	WAITFOR DELAY '00:00:15'
COMMIT TRAN

EXEC PROC_PHANTOM_T1_LAM

--TRANSACTION 2
IF OBJECT_ID('PROC_PHANTOM_T2_LAM', N'P') IS NOT NULL DROP PROC PROC_PHANTOM_T2_LAM
GO
CREATE PROC PROC_PHANTOM_T2_LAM
	@id_employee nchar(10),
	@name nvarchar(10),
	@gmail nvarchar(50),
	@id_card nvarchar(50),
	@address nchar(10),
	@position nchar(10),
	@agency nchar(10),
	@isActive int
AS
BEGIN TRAN
	INSERT [dbo].[EMPLOYEE] ([id_employee], [name], [gmail], [id_card], [address], [position], [agency], [isActive]) 
	VALUES (@id_employee, @name, @gmail, @id_card, @address, @position, @agency, @isActive)	
COMMIT TRAN

--FIX => TRANSACTION 1--
IF OBJECT_ID('PROC_PHANTOM_T1_LAM', 'P') IS NOT NULL DROP PROC PROC_PHANTOM_T1_LAM
GO
CREATE PROC PROC_PHANTOM_T1_LAM
AS
BEGIN TRAN
	SELECT * 
	FROM EMPLOYEE with (Serializable) 
	WHERE isActive = 1
	WAITFOR DELAY '00:00:15'
COMMIT TRAN

--AnHoa
--Mô tả: Khách hàng đang xem danh sách thuộc loại món A, thì quản lý thêm món thuộc loại món A vào.

--TRANSACTION 1:
IF OBJECT_ID('PROC_PHANTOM_T1_ANHOA', 'p') is not null DROP PROC PROC_PHANTOM_T1_ANHOA
GO
CREATE PROC PROC_PHANTOM_T1_ANHOA @id_td nchar(10), @id_agency nchar(10)
AS
BEGIN TRAN
	SELECT D.id_dish, D.dish_name, T.type_dish_name, A.agency_name, M.unit
	FROM DISH D, AGENCY A, MENU M, TYPE_DISH T
	WHERE T.id_type_dish = @id_td AND T.id_type_dish = D.type_dish AND M.id_dish = D.id_dish AND M.id_agency = A.id_agency
	WAITFOR DELAY '00:00:15'
COMMIT TRAN
EXEC PROC_PHANTOM_T1_ANHOA 'td_1', 'ag_1'

--TRANSACTION 2:
IF OBJECT_ID('PROC_PHANTOM_T2_ANHOA', 'p') is not null DROP PROC PROC_PHANTOM_T2_ANHOA
GO
CREATE PROC PROC_PHANTOM_T2_ANHOA @idagency nchar(10), @iddish nchar(10), @unit int	
AS
BEGIN TRAN
	INSERT INTO MENU(id_agency, id_dish, unit, isActive)
	VALUES (@idagency, @iddish, @unit, 1)

COMMIT TRAN
EXEC PROC_PHANTOM_T2_ANHOA 'ag_2', 'dish_3', 20

--TRANSACTION 1 FIX:
IF OBJECT_ID('PROC_PHANTOM_T1_ANHOA', 'p') is not null DROP PROC PROC_PHANTOM_T1_ANHOA
GO
CREATE PROC PROC_PHANTOM_T1_ANHOA @id_td nchar(10), @id_agency nchar(10)
AS
BEGIN TRAN
SET TRAN ISOLATION LEVEL SERIALIZABLE  --Giải quyết lỗi Phantom
	SELECT D.id_dish, D.dish_name, T.type_dish_name, A.agency_name, M.unit
	FROM DISH D, AGENCY A, MENU M, TYPE_DISH T
	WHERE T.id_type_dish = @id_td AND T.id_type_dish = D.type_dish AND M.id_dish = D.id_dish AND M.id_agency = A.id_agency
	WAITFOR DELAY '00:00:15'
COMMIT TRAN
EXEC PROC_PHANTOM_T1_ANHOA 'td_1', 'ag_1'


--TrungDuc
USE HuongVietRestaurant
GO

--Người quản lý A xem toàn bộ đơn hàng (chưa xong) thì có đơn hàng mới được tạo.
--T1: quản lý A xem toàn bộ đơn hàng
IF OBJECT_ID('PROC_PHANTOM_T1_TRUNGDUC', 'p') is not null DROP PROC PROC_PHANTOM_T1_TRUNGDUC
GO
CREATE PROC PROC_PHANTOM_T1_TRUNGDUC
	@id_agency nchar(10)
AS
BEGIN TRAN
	SELECT COUNT(*) 
	FROM BILL b
	WHERE b.agency = @id_agency and b.isActive = 1
	WAITFOR DELAY '00:00:10'
COMMIT TRAN 

EXEC PROC_PHANTOM_T1_TRUNGDUC N'ag_2'

--T2: Đơn hàng mới được tạo
IF OBJECT_ID('PROC_PHANTOM_T2_TRUNGDUC', 'p') is not null DROP PROC PROC_PHANTOM_T2_TRUNGDUC
GO
CREATE PROC PROC_PHANTOM_T2_TRUNGDUC
	@id_bill nchar(10),
	@agency nchar(10),
	@customer nchar(10),
	@status nchar(10),
	@order nchar(10),
	@payment_method nchar(10),
	@total float,
	@fee nchar(10),
	@isActive float
AS
BEGIN TRAN
	INSERT INTO BILL(id_bill,agency,customer,status,[order],payment_method,total,fee,isActive)
	VALUES (@id_bill,@agency,@customer,@status,@order,@payment_method,@total,@fee,@isActive)
COMMIT TRAN

EXEC PROC_PHANTOM_T2_TRUNGDUC 
N'bill_5    ', N'ag_2      ', N'cus_2     ', N'sta_2     ', N'order_2   ', N'pay_1     ', 69000, N'fee_1     ', 1

--T1 FIX: quản lý A xem toàn bộ đơn hàng
GO
IF OBJECT_ID('PROC_PHANTOM_T1_TRUNGDUC', 'p') is not null DROP PROC PROC_PHANTOM_T1_TRUNGDUC
GO
CREATE PROC PROC_PHANTOM_T1_TRUNGDUC
	@id_agency nchar(10)
AS
BEGIN TRAN
	SELECT COUNT(*) 
	FROM BILL b WITH (Serializable)
	WHERE b.agency = @id_agency and b.isActive = 1
	WAITFOR DELAY '00:00:10'
COMMIT TRAN 

EXEC PROC_PHANTOM_T1_TRUNGDUC N'ag_2'

--Unrepeatable Read--
--ChuanVo
-- Khách hàng đang xem thông tin món ăn thì người quản lý cập nhật giá của món ăn.
--TRANSACTION 1--
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T1_CHUAN', 'P') IS NOT NULL DROP PROC PROC_UNREPEATABLEREAD_T1_CHUAN
GO
CREATE PROC PROC_UNREPEATABLEREAD_T1_CHUAN @id_dish nchar(10)
AS
BEGIN TRAN
	SELECT *
	FROM DISH 
	WHERE id_dish = @id_dish and d.isActive = 1
	WAITFOR DELAY '00:00:15'


	SELECT *
	FROM DISH 
	WHERE id_dish = @id_dish and d.isActive = 1

COMMIT TRAN

--TRANSACTION 2--
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T2_CHUAN', 'P') IS NOT NULL DROP PROC PROC_UNREPEATABLEREAD_T2_CHUAN
GO
CREATE PROC PROC_UNREPEATABLEREAD_T2_CHUAN @id_dish nchar(10), @price nvarchar(50)
AS
BEGIN TRAN
	UPDATE DISH 
	SET [price] = @price
	WHERE id_dish = @id_dish and isActive = 1 
COMMIT TRAN

--FIX =>TRANSACTION 1--
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T1_CHUAN', N'P') IS NOT NULL DROP PROC PROC_UNREPEATABLEREAD_T1_CHUAN
GO
CREATE PROC PROC_UNREPEATABLEREAD_T1_CHUAN @id_dish nchar(10)
AS
BEGIN TRAN
	SELECT *
	FROM DISH WITH (RepeatableRead)
	WHERE id_dish = @id_dish and isActive = 1 
	WAITFOR DELAY '00:00:15'

	SELECT *
	FROM DISH
	WHERE id_dish = @id_dish and isActive = 1 

COMMIT TRAN

--Lam
-- Khách hàng đang xem thông tin món ăn thì người quản lý cập nhật hình ảnh của món ăn.
--TRANSACTION 1--
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T1_LAM', 'P') IS NOT NULL DROP PROC PROC_UNREPEATABLEREAD_T1_LAM
GO
CREATE PROC PROC_UNREPEATABLEREAD_T1_LAM @id_dish nchar(10)
AS
BEGIN TRAN
	SELECT *
	FROM DISH 
	WHERE id_dish = @id_dish and d.isActive = 1
	WAITFOR DELAY '00:00:15'


	SELECT *
	FROM DISH 
	WHERE id_dish = @id_dish and d.isActive = 1

COMMIT TRAN

--TRANSACTION 2--
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T2_LAM', 'P') IS NOT NULL DROP PROC PROC_UNREPEATABLEREAD_T2_LAM
GO
CREATE PROC PROC_UNREPEATABLEREAD_T2_LAM @id_dish nchar(10), @image nvarchar(50)
AS
BEGIN TRAN
	UPDATE DISH 
	SET [image] = @image
	WHERE id_dish = @id_dish and isActive = 1 
COMMIT TRAN

--FIX =>TRANSACTION 1--
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T1_LAM', N'P') IS NOT NULL DROP PROC PROC_UNREPEATABLEREAD_T1_LAM
GO
CREATE PROC PROC_UNREPEATABLEREAD_T1_LAM @id_dish nchar(10)
AS
BEGIN TRAN
	SELECT *
	FROM DISH WITH (RepeatableRead)
	WHERE id_dish = @id_dish and isActive = 1 
	WAITFOR DELAY '00:00:15'

	SELECT *
	FROM DISH
	WHERE id_dish = @id_dish and isActive = 1 

COMMIT TRAN

--Lang
--Admin đang xem danh sách món ăn theo loại 
--thì quản lý B xóa loại món ăn đó đi. 
--TRANSACTION 1--
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T1_LANG', N'P') IS NOT NULL DROP PROC PROC_UNREPEATABLEREAD_T1_LANG
GO
CREATE PROC PROC_UNREPEATABLEREAD_T1_LANG
	@id_type nchar(10)
AS
BEGIN TRAN
	SELECT Count(*) 
	FROM DISH d, TYPE_DISH td
	WHERE d.type_dish = @id_type and d.type_dish = td.id_type_dish and td.isActive = 1 and d.isActive = 1
	WAITFOR DELAY '00:00:15'

	SELECT *
	FROM DISH d1, TYPE_DISH td1
	WHERE d1.type_dish = @id_type and d1.type_dish = td1.id_type_dish and td1.isActive = 1 and d1.isActive = 1
	
COMMIT TRAN
GO

EXEC PROC_UNREPEATABLEREAD_T1_LANG N'td_1'

  --TRANSACTION 2--
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T2_LANG', N'P') IS NOT NULL DROP PROC PROC_UNREPEATABLEREAD_T2_LANG
GO
CREATE PROC PROC_UNREPEATABLEREAD_T2_LANG
	@id_type nchar(10)
AS
BEGIN TRAN
	UPDATE TYPE_DISH 
	SET isActive = 0
	WHERE id_type_dish = @id_type and isActive = 1 
COMMIT TRAN
GO

EXEC PROC_UNREPEATABLEREAD_T2_LANG N'td_1'

--TRANSACTION 1 FIX --
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T1_LANG', N'P') IS NOT NULL DROP PROC PROC_UNREPEATABLEREAD_T1_LANG
GO
CREATE PROC PROC_UNREPEATABLEREAD_T1_LANG
	@id_type nchar(10)
AS
BEGIN TRAN
	SELECT Count(*) 
	FROM DISH d, TYPE_DISH td WITH (RepeatableRead)
	WHERE d.type_dish = @id_type and d.type_dish = td.id_type_dish and td.isActive = 1 and d.isActive = 1
	WAITFOR DELAY '00:00:10'

	SELECT *
	FROM DISH d1, TYPE_DISH td1
	WHERE d1.type_dish = @id_type and d1.type_dish = td1.id_type_dish and td1.isActive = 1 and d1.isActive = 1
	
COMMIT TRAN
GO

EXEC PROC_UNREPEATABLEREAD_T1_LANG N'td_1'


--TrungDuc
--Khách A xem danh sách các món ăn tại chi nhánh 1 có  SL >=1,
-- khách B mua hết 1 món trong đó ( update SL =0)
--TRANSACTION 1--
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T1_TRUNGDUC', N'P') IS NOT NULL DROP PROC PROC_UNREPEATABLEREAD_T1_TRUNGDUC
GO
CREATE PROC PROC_UNREPEATABLEREAD_T1_TRUNGDUC
	@id_agency nchar(10)
AS
BEGIN TRAN
	SELECT mn.id_agency, COUNT(*) 
	FROM MENU mn
	WHERE mn.id_agency = @id_agency and mn.isActive = 1
	GROUP BY mn.id_agency
	HAVING COUNT(*) >= 1
	WAITFOR DELAY '00:00:0'

	SELECT *
	FROM MENU mn1
	WHERE mn1.id_agency = @id_agency and mn1.isActive = 1 and mn1.unit >= 1
	
COMMIT TRAN
GO

EXEC PROC_UNREPEATABLEREAD_T1_TRUNGDUC N'ag_1'

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

EXEC PROC_UNREPEATABLEREAD_T2_TRUNGDUC N'ag_1', N'dish_2', 26
GO
--TRANSACTION 1 FIX--
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T1_TRUNGDUC', N'P') IS NOT NULL DROP PROC PROC_UNREPEATABLEREAD_T1_TRUNGDUC
GO
CREATE PROC PROC_UNREPEATABLEREAD_T1_TRUNGDUC
	@id_agency nchar(10)
AS
BEGIN TRAN
	SELECT mn.id_agency, COUNT(*) 
	FROM MENU mn WITH (RepeatableRead)
	WHERE mn.id_agency = @id_agency and mn.isActive = 1
	GROUP BY mn.id_agency
	HAVING COUNT(*) >= 1
	WAITFOR DELAY '00:00:0'

	SELECT *
	FROM MENU mn1
	WHERE mn1.id_agency = @id_agency and mn1.isActive = 1 and mn1.unit >= 1
	
COMMIT TRAN
GO

EXEC PROC_UNREPEATABLEREAD_T1_TRUNGDUC N'ag_1'

--AnHoa
--Mô tả: Khách hàng tìm kiếm danh sách món dưới 50.000. Trong lúc đó quản lý cập nhật giá 1 món ăn giá từ dưới 50.000 thành trên 50.000 -> dẫn đến món ăn nằm ngoài danh sách khách hàng tìm kiếm.
--TRANSACTION 1:
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T1_ANHOA', 'p') is not null DROP PROC PROC_UNREPEATABLEREAD_T1_ANHOA
GO
CREATE PROC PROC_UNREPEATABLEREAD_T1_ANHOA @id_agency nchar(10), @price int
AS
BEGIN TRAN
	SELECT D.id_dish, T.type_dish_name, D.dish_name, A.agency_name, M.unit, D.price
	FROM DISH D, AGENCY A, MENU M, TYPE_DISH T
	WHERE T.id_type_dish = D.type_dish AND M.id_dish = D.id_dish AND M.id_agency = A.id_agency AND D.price <= @price
	ORDER BY D.price ASC
	WAITFOR DELAY '00:00:15'
	SELECT D.id_dish, T.type_dish_name, D.dish_name, A.agency_name, M.unit, D.price
	FROM DISH D, AGENCY A, MENU M, TYPE_DISH T
	WHERE T.id_type_dish = D.type_dish AND M.id_dish = D.id_dish AND M.id_agency = A.id_agency AND D.price <= @price
	ORDER BY D.price ASC
COMMIT TRAN  
EXEC PROC_UNREPEATABLEREAD_T1_ANHOA 'ag_1', 50000

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
EXEC PROC_UNREPEATABLEREAD_T2_ANHOA 'dish_5', 70000

--TRANSACTION 1 FIX:
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T1_ANHOA', 'p') is not null DROP PROC PROC_UNREPEATABLEREAD_T1_ANHOA
GO
CREATE PROC PROC_UNREPEATABLEREAD_T1_ANHOA @id_agency nchar(10), @price int
AS
BEGIN TRAN
SET TRAN ISOLATION LEVEL REPEATABLE READ
	SELECT D.id_dish, T.type_dish_name, D.dish_name, A.agency_name, M.unit, D.price
	FROM DISH D, AGENCY A, MENU M, TYPE_DISH T
	WHERE T.id_type_dish = D.type_dish AND M.id_dish = D.id_dish AND M.id_agency = A.id_agency AND D.price <= @price
	ORDER BY D.price ASC
	WAITFOR DELAY '00:00:15'
	SELECT D.id_dish, T.type_dish_name, D.dish_name, A.agency_name, M.unit, D.price
	FROM DISH D, AGENCY A, MENU M, TYPE_DISH T
	WHERE T.id_type_dish = D.type_dish AND M.id_dish = D.id_dish AND M.id_agency = A.id_agency AND D.price <= @price
	ORDER BY D.price ASC
COMMIT TRAN     
EXEC PROC_UNREPEATABLEREAD_T1_ANHOA 'ag_1', 50000

--DEADLOCK--
--ChuanVo 
--Giao tác T1:
--		+ UPDATE DISH set dish_name = 'món ăn 1' where id_dish = 'X'
--		+ wait(15'')
-- 		+ UPDATE TYPE_DISH set type_name = 'loại 1' where id_type = 'P'  
--Giao tác T2:
--		+ UPDATE DISH set dish_name = 'món ăn 1' where id_dish = 'X' 
--		+ wait(15'')
-- 		+ UPDATE TYPE_DISH set type_name = 'loại 1' where id_type = 'P'  
--TRANSACTION 1 --
IF OBJECT_ID('PROC_DEADLOCK_T1_CHUAN', N'P') IS NOT NULL DROP PROC PROC_DEADLOCK_T1_CHUAN
GO
CREATE PROC PROC_DEADLOCK_T1_CHUAN
	@id_dish nchar(10),
	@dish_name nvarchar(50),
	@id_type_dish nchar(10),
	@type_dish_name nvarchar(50)
AS
BEGIN TRAN
	UPDATE DISH
	SET dish_name = @dish_name
	WHERE id_dish = @id_dish
	WAITFOR DELAY '00:00:10'

	UPDATE TYPE_DISH	
	SET type_dish_name = @type_dish_name
	WHERE id_type_dish = @id_type_dish
	
COMMIT TRAN

EXEC PROC_DEADLOCK_T1_CHUAN 'dish_1', N'Rong biet vuot dai duong', 'td_1', 'Ngon'


--TRANSACTION 2 --
IF OBJECT_ID('PROC_DEADLOCK_T2_CHUAN', N'P') IS NOT NULL DROP PROC PROC_DEADLOCK_T2_CHUAN
GO
CREATE PROC PROC_DEADLOCK_T2_CHUAN
	@id_dish nchar(10),
	@dish_name nvarchar(50),
	@id_type_dish nchar(10),
	@type_dish_name nvarchar(50)
AS
BEGIN TRAN
	UPDATE TYPE_DISH	
	SET type_dish_name = @type_dish_name
	WHERE id_type_dish = @id_type_dish
	WAITFOR DELAY '00:00:10'

	UPDATE DISH
	SET dish_name = @dish_name
	WHERE id_dish = @id_dish
	
COMMIT TRAN
GO

EXEC PROC_DEADLOCK_T2_CHUAN 'dish_1', N'Rong biet vuot dai duong', 'td_1', 'Ngon'

--TRANSACTION 2 FIX--
IF OBJECT_ID('PROC_DEADLOCK_T2_CHUAN', N'P') IS NOT NULL DROP PROC PROC_DEADLOCK_T2_CHUAN
GO
CREATE PROC PROC_DEADLOCK_T2_CHUAN
	@id_dish nchar(10),
	@dish_name nvarchar(50),
	@id_type_dish nchar(10),
	@type_dish_name nvarchar(50)
AS
BEGIN TRAN
	UPDATE TYPE_DISH WITH (NOLOCK) 
	SET type_dish_name = @type_dish_name
	WHERE id_type_dish = @id_type_dish
	WAITFOR DELAY '00:00:10'

	UPDATE DISH
	SET dish_name = @dish_name
	WHERE id_dish = @id_dish
	
COMMIT TRAN
GO

EXEC PROC_DEADLOCK_T2_CHUAN 'dish_1', N'Rong biet vuot dai duong', 'td_1', 'Ngon'


--Lam 
--Giao tác T1:
--		+ SELECT * from TYPE_DISH where id_type_dish = '01'
--		+ wait(5")
-- 		+ UPDATE TYPE_DISH set type_dish_name = 'loại món gì đó ?' where id_type_dish = '01'  
--Giao tác T2:
--		+ SELECT * from TYPE_DISH where id_type_dish = '01'
--		+ wait(15'')
-- 		+ UPDATE TYPE_DISH set dish_name = 'loại món mặn chằng' where id_type_dish = '01' 

--TRANSACTION 1 --
IF OBJECT_ID('PROC_DEADLOCK_T1_LAM', N'P') IS NOT NULL DROP PROC PROC_DEADLOCK_T1_LAM
GO
CREATE PROC PROC_DEADLOCK_T1_LAM
	@id_type_dish nchar(10),
	@type_dish_name nvarchar(50)
AS
BEGIN TRAN
	SELECT * 
	FROM TYPE_DISH WITH (HOLDLOCK)
	WHERE id_type_dish = @id_type_dish
	WAITFOR DELAY '00:00:10'

	UPDATE TYPE_DISH WITH (XLOCK)		
	SET type_dish_name = @type_dish_name
	WHERE id_type_dish = @id_type_dish
COMMIT TRAN

EXEC PROC_DEADLOCK_T1_LAM 'td_1', N'Món nước'

--TRANSACTION 2 --
IF OBJECT_ID('PROC_DEADLOCK_T2_LAM', N'P') IS NOT NULL DROP PROC PROC_DEADLOCK_T2_LAM
GO
CREATE PROC PROC_DEADLOCK_T2_LAM
	@id_type_dish nchar(10),
	@type_dish_name nvarchar(50)
AS
BEGIN TRAN
	SELECT * 
	FROM TYPE_DISH WITH (HOLDLOCK)
	WHERE id_type_dish = @id_type_dish

	UPDATE TYPE_DISH WITH (XLOCK)	
	SET type_dish_name = @type_dish_name
	WHERE id_type_dish = @id_type_dish

COMMIT TRAN
GO

EXEC PROC_DEADLOCK_T2_LAM 'td_1', N'Món tráng miệng'

--============================================= FIX =============================================--
--TRANSACTION 1 --
IF OBJECT_ID('PROC_DEADLOCK_T1_LAM', N'P') IS NOT NULL DROP PROC PROC_DEADLOCK_T1_LAM
GO
CREATE PROC PROC_DEADLOCK_T1_LAM
	@id_type_dish nchar(10),
	@type_dish_name nvarchar(50)
AS
BEGIN TRAN
	SELECT * 
	FROM TYPE_DISH WITH (NOLOCK)
	WHERE id_type_dish = @id_type_dish
	WAITFOR DELAY '00:00:10'

	UPDATE TYPE_DISH WITH (XLOCK)		
	SET type_dish_name = @type_dish_name
	WHERE id_type_dish = @id_type_dish
COMMIT TRAN

EXEC PROC_DEADLOCK_T1_LAM 'td_1', N'Món nước'

--TRANSACTION 2 FIX--
IF OBJECT_ID('PROC_DEADLOCK_T2_LAM', N'P') IS NOT NULL DROP PROC PROC_DEADLOCK_T2_LAM
GO
CREATE PROC PROC_DEADLOCK_T2_LAM
	@id_type_dish nchar(10),
	@type_dish_name nvarchar(50)
AS
BEGIN TRAN
	SELECT * 
	FROM TYPE_DISH
	WHERE id_type_dish = @id_type_dish

	UPDATE TYPE_DISH WITH (NOLOCK) 
	SET type_dish_name = @type_dish_name
	WHERE id_type_dish = @id_type_dish
	
COMMIT TRAN
GO

EXEC PROC_DEADLOCK_T2_LAM 'td_1', N'Món tráng miệng'


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
	FROM MENU m  WITH (HOLDLOCK)
	WHERE m.id_dish = @id_dish and m.id_agency = @id_agency and m.isActive = 1
	WAITFOR DELAY '00:00:10'
	UPDATE MENU WITH (XLOCK) 
	SET unit = @unit
	WHERE id_dish = @id_dish and id_agency = @id_agency and isActive = 1	
COMMIT TRAN
GO
EXEC PROC_DEADLOCK_T1_LANG 'dish_1', N'ag_1', 60

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
	FROM MENU m WITH (HOLDLOCK) 
	WHERE m.id_dish = @id_dish and m.id_agency = @id_agency and m.isActive = 1 
	UPDATE MENU WITH (XLOCK) 
	SET unit = @unit
	WHERE id_dish = @id_dish and id_agency = @id_agency and isActive = 1
COMMIT TRAN
GO
EXEC PROC_DEADLOCK_T2_LANG N'dish_1', N'ag_1', 100 

--============================================= FIX =============================================--
--TRANSACTION 1 FIX--
IF OBJECT_ID('PROC_DEADLOCK_T1_LANG', N'P') IS NOT NULL DROP PROC PROC_DEADLOCK_T1_LANG
GO
CREATE PROC PROC_DEADLOCK_T1_LANG
	@id_dish nchar(10),
	@id_agency nchar(10),
	@unit int
AS
BEGIN TRAN
	SELECT * 
	FROM MENU m  WITH (NOLOCK)
	WHERE m.id_dish = @id_dish and m.id_agency = @id_agency and m.isActive = 1
	WAITFOR DELAY '00:00:10'
	UPDATE MENU WITH (XLOCK) 
	SET unit = @unit
	WHERE id_dish = @id_dish and id_agency = @id_agency and isActive = 1	
COMMIT TRAN
GO
EXEC PROC_DEADLOCK_T1_LANG 'dish_1', N'ag_1', 60


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
	FROM MENU m WITH (NOLOCK) 
	WHERE m.id_dish = @id_dish and m.id_agency = @id_agency and m.isActive = 1 
	UPDATE MENU WITH (XLOCK) 
	SET unit = @unit
	WHERE id_dish = @id_dish and id_agency = @id_agency and isActive = 1
COMMIT TRAN
GO
EXEC PROC_DEADLOCK_T2_LANG N'dish_1', N'ag_1', 100 



--AnHoa

--Mô tả: 
	--Giao tác T1: 
	--Quản lý 1 xem danh sách các món hiện có (khi này sẽ giữ khóa đọc)
	--Delay 15s (Giao tác B thực hiện)
	--Quản lý 1 muốn thêm một món vào danh sách nhưng không thực hiện được (chờ giao tác B nhả khóa).
	--Giao tác T2:
	--Quản lý 2 xem danh sách các món hiện có (giữ khóa đọc)
	--Quản lý 2 xóa 1 món trong danh sách nhưng không thực hiện được vì ở giao tác A chưa nhả khóa (chờ giao tác A). Và giao tác B cũng không nhả khóa.
	-- => Dẫn đến 2 tác chờ nhau và deadlock xảy ra

--TRANSACTION 1:
IF OBJECT_ID('PROC_DEADLOCK_T1_ANHOA', 'p') is not null DROP PROC PROC_DEADLOCK_T1_ANHOA
GO
CREATE PROC PROC_DEADLOCK_T1_ANHOA @id_dish nchar(10), @id_typedish nchar(10), @dishname nvarchar(50), @price int, @image nvarchar(50)
AS
BEGIN TRAN
	SELECT *
	FROM DISH WITH (HOLDLOCK)  --Phát khóa đọc trên bảng DISH
	WAITFOR DELAY '00:00:10'
	INSERT INTO DISH WITH (XLOCK)(id_dish, type_dish, dish_name, price, image, isActive)  --Phát khóa ghi (nhưng không được vì khóa đọc chưa mở)
	VALUES (@id_dish, @id_typedish, @dishname, @price, @image, 1)
COMMIT TRAN

EXEC PROC_DEADLOCK_T1_ANHOA 'dish_21', 'td_1', 'Bánh tráng', 10000, './'

SELECT *
FROM DISH

--TRANSACTION 2:
IF OBJECT_ID('PROC_DEADLOCK_T2_ANHOA', 'p') is not null DROP PROC PROC_DEADLOCK_T2_ANHOA
GO
CREATE PROC PROC_DEADLOCK_T2_ANHOA @id_dish nchar(10)
AS
BEGIN TRAN
	SELECT *
	FROM DISH WITH (HOLDLOCK)  --Phát khóa đọc trên bảng DISH
	UPDATE DISH WITH (XLOCK) 
	SET isActive = 0
	WHERE id_dish = @id_dish
COMMIT TRAN

EXEC PROC_DEADLOCK_T2_ANHOA 'dish_1'

--============================================= FIX =============================================--
--TRANSACTION 1:
IF OBJECT_ID('PROC_DEADLOCK_T1_ANHOA', 'p') is not null DROP PROC PROC_DEADLOCK_T1_ANHOA
GO
CREATE PROC PROC_DEADLOCK_T1_ANHOA @id_dish nchar(10), @id_typedish nchar(10), @dishname nvarchar(50), @price int, @image nvarchar(50)
AS
BEGIN TRAN
	SELECT *
	FROM DISH WITH (NOLOCK)  --Phát khóa đọc trên bảng DISH
	WAITFOR DELAY '00:00:10'
	INSERT INTO DISH WITH (XLOCK)(id_dish, type_dish, dish_name, price, image, isActive)  --Phát khóa ghi (nhưng không được vì khóa đọc chưa mở)
	VALUES (@id_dish, @id_typedish, @dishname, @price, @image, 1)
COMMIT TRAN

EXEC PROC_DEADLOCK_T1_ANHOA 'dish_21', 'td_1', 'Bánh tráng', 10000, './'
--TRANSACTION 2 FIX:
IF OBJECT_ID('PROC_DEADLOCK_T2_ANHOA', 'p') is not null DROP PROC PROC_DEADLOCK_T2_ANHOA
GO
CREATE PROC PROC_DEADLOCK_T2_ANHOA @id_dish nchar(10)
AS
BEGIN TRAN
	SELECT *
	FROM DISH WITH (NOLOCK) 

	UPDATE DISH WITH (XLOCK) 
	SET isActive = 0
	WHERE id_dish = @id_dish
COMMIT TRAN
EXEC PROC_DEADLOCK_T2_ANHOA 'dish_1'



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

	UPDATE BILL WITH(XLOCK)
	SET status = @status
	WHERE id_bill = @id_bill and agency = @id_agency and isActive = 1

COMMIT TRAN
GO

EXEC PROC_DEADLOCK_T2_TRUNGDUC N'bill_1', N'ag_1', N'sta_3'

--============================================= FIX =============================================--
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
	FROM BILL b WITH(NOLOCK)
	WHERE b.id_bill = @id_bill and b.agency = @id_agency and b.isActive = 1
	WAITFOR DELAY '00:00:10'

	UPDATE BILL WITH(XLOCK)
	SET status = @status
	WHERE id_bill = @id_bill and agency = @id_agency and isActive = 1

COMMIT TRAN
GO

EXEC PROC_DEADLOCK_T1_TRUNGDUC N'bill_1', N'ag_1', N'sta_4'

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

	UPDATE BILL WITH(XLOCK)
	SET status = @status
	WHERE id_bill = @id_bill and agency = @id_agency and isActive = 1

COMMIT TRAN
GO

EXEC PROC_DEADLOCK_T2_TRUNGDUC N'bill_1', N'ag_1', N'sta_3'