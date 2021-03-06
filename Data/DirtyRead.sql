USE HuongVietRestaurant
GO

--============> DIRTY READ <==========

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
	@id_agency nchar(10)
AS
BEGIN TRAN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SELECT M.id_agency, D.id_dish, M.unit, D.dish_name, D.type_dish, D.image, D.price
	FROM MENU M JOIN DISH D 
	ON id_agency = @id_agency AND M.id_dish = D.id_dish AND M.isActive = 1
COMMIT TRAN
GO

----EXEC PROC_DIRTYREAD_T2_LANG 'dish_5'

-- TRANSACTION 2 FIX --
IF OBJECT_ID('PROC_DIRTYREAD_T2_LANG', N'P') IS NOT NULL DROP PROC PROC_DIRTYREAD_T2_LANG
GO
CREATE PROC PROC_DIRTYREAD_T2_LANG
	@id_agency nchar(10)
AS
BEGIN TRAN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	SELECT M.id_agency, D.id_dish, M.unit, D.dish_name, D.type_dish, D.image, D.price
		FROM MENU M JOIN DISH D with (RepeatableRead)
		ON id_agency = @id_agency AND M.id_dish = D.id_dish AND M.isActive = 1 
	
COMMIT TRAN
GO

--EXEC PROC_DIRTYREAD_T2_LANG 'dish_5'



--Lam
-- Mô tả: Quản lý cửa hàng cập nhật email cho nhân viên cấp dưới (chưa commit) thì nhân viên khác vào xem thông tin của nhân viên được cập nhật

-- T1: Quản lý cửa hàng cập nhật position cho nhân viên cấp dưới
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
SET TRAN ISOLATION LEVEL READ UNCOMMITTED  -- Đảm bảo cho việc xảy ra DirtyRead
	SELECT M.id_agency, D.id_dish, M.unit, D.dish_name, D.type_dish, D.image, D.price
	FROM MENU M JOIN DISH D 
	ON id_agency = @id_agency AND M.id_dish = D.id_dish AND M.isActive = 1
COMMIT TRAN

EXEC PROC_DIRTYREAD_T2_ANHOA 'ag_1'

--TRANSACTION 2 FIX:
IF OBJECT_ID('PROC_DIRTYREAD_T2_ANHOA', 'p') is not null DROP PROC PROC_DIRTYREAD_T2_ANHOA
GO
CREATE PROC PROC_DIRTYREAD_T2_ANHOA @id_agency nchar(10)
AS
BEGIN TRAN
SET TRAN ISOLATION LEVEL READ COMMITTED  --Giải quyết lỗi DirtyRead
	SELECT M.id_agency, D.id_dish, M.unit, D.dish_name, D.type_dish, D.image, D.price
	FROM MENU M JOIN DISH D 
	ON id_agency = @id_agency AND M.id_dish = D.id_dish AND M.isActive = 1
COMMIT TRAN
EXEC PROC_DIRTYREAD_T2_ANHOA 'ag_1'

--TRUNGDUC
-- Mô tả: Quản lý cửa hàng cập nhật tên cho nhân viên cấp dưới (chưa commit) thì nhân viên khác vào xem thông tin của nhân viên được cập nhật

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
