USE HuongVietRestaurant
GO

--*************************************************************--
--Dirty read--
--*************************************************************--
--Xem thông tin nhân viên.
IF OBJECT_ID('PROC_DIRTYREAD_T2_LAM', 'p') IS NOT NULL DROP PROC PROC_DIRTYREAD_T2_LAM
GO
CREATE PROC PROC_DIRTYREAD_T2_LAM
AS
BEGIN TRAN
	SET TRAN ISOLATION LEVEL READ UNCOMMITTED  
	SELECT * 
	FROM EMPLOYEE E, ADDRESS A
	WHERE E.isActive = '1' AND E.address = A.id_address
COMMIT TRAN

--cập nhật tên nhân viên
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
------------------------------------------------------------------------------------------------------
--Cập nhật giá món ăn
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
------------------------------------------------------------------------------------------------------
--Cập nhật hình ảnh món ăn
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
------------------------------------------------------------------------------------------------------
--cập nhật số lượng món ăn trong menu
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
------------------------------------------------------------------------------------------------------
--Sửa gmail nhân viên
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
--Xem thông tin nhân viên
--Đã có proc ở trên
------------------------------------------------------------------------------------------------------
--*************************************************************--
--Lost update--
--*************************************************************--
--2 quản lý cùng cập nhật giá món ăn
--T1:
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

--T2
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
------------------------------------------------------------------------------------------------------
--2 quản lý cùng cập nhật tình trạng bill
--T1
IF OBJECT_ID('PROC_LOSTUPDATE_T1_LAM', N'P') IS NOT NULL DROP PROC PROC_LOSTUPDATE_T1_LAM
GO
CREATE PROC PROC_LOSTUPDATE_T1_LAM 
	@id_bill nchar(10),
	@agency nchar(10),
	@status nchar(10)
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

--T2
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

--T1 FIX
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
------------------------------------------------------------------------------------------------------
--Quản lý 1 sửa số lượng món ăn thì quản lý khác vào bấm thanh toán
--Cập nhật số lượng món ăn trong menu
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

--Thanh toán món ăn trong menu
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

--T2 FIX --
IF OBJECT_ID('PROC_LOSTUPDATE_T2_LANG', N'P') IS NOT NULL DROP PROC PROC_LOSTUPDATE_T2_LANG
GO
CREATE PROC PROC_LOSTUPDATE_T2_LANG
	@id_dish nchar(10),
	@unit int,
	@id_agency nchar(10)
AS
BEGIN TRAN
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
	DECLARE @unitnew int

	SELECT @unitnew = unit
	FROM MENU
	WHERE id_dish = @id_dish and id_agency = @id_agency and isActive = 1
	SET @unitnew = @unitnew - @unit
	
	UPDATE MENU 
	SET unit = @unitnew
	WHERE id_dish = @id_dish and id_agency = @id_agency and isActive = 1
COMMIT TRAN
------------------------------------------------------------------------------------------------------
--2 quản lý cùng cập nhật tên món ăn
--T1
IF OBJECT_ID('PROC_LOSTUPDATE_T1_TRUNGDUC', 'p') is not null DROP PROC PROC_LOSTUPDATE_T1_TRUNGDUC
GO
CREATE PROC PROC_LOSTUPDATE_T1_TRUNGDUC
	@id_dish nchar(10),
	@name nchar(50)
AS
BEGIN TRAN
	SELECT *
	FROM DISH d 
	WHERE id_dish = @id_dish and isActive = 1
	WAITFOR DELAY '00:00:10'
	
	UPDATE DISH 
	SET dish_name = @name
	WHERE id_dish = @id_dish and isActive = 1
COMMIT TRAN

--T2
IF OBJECT_ID('PROC_LOSTUPDATE_T2_TRUNGDUC', 'p') is not null DROP PROC PROC_LOSTUPDATE_T2_TRUNGDUC
GO
CREATE PROC PROC_LOSTUPDATE_T2_TRUNGDUC
	@id_dish nchar(10),
	@name nchar(50)
AS
BEGIN TRAN
	SELECT *
	FROM DISH d 
	WHERE id_dish = @id_dish and isActive = 1

	UPDATE DISH 
	SET dish_name = @name
	WHERE id_dish = @id_dish and isActive = 1
COMMIT TRAN

--T2 FIX:
IF OBJECT_ID('PROC_LOSTUPDATE_T2_TRUNGDUC', 'p') is not null DROP PROC PROC_LOSTUPDATE_T2_TRUNGDUC
GO
CREATE PROC PROC_LOSTUPDATE_T2_TRUNGDUC
	@id_dish nchar(10),
	@name nchar(50)
AS
BEGIN TRAN
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
	SELECT *
	FROM DISH d 
	WHERE id_dish = @id_dish and isActive = 1

	UPDATE DISH 
	SET dish_name = @name
	WHERE id_dish = @id_dish and isActive = 1
COMMIT TRAN
--*************************************************************--
--Phantom--
--*************************************************************--
--Thêm món ăn vào menu
IF OBJECT_ID('PROC_PHANTOM_T2_CHUANVO', N'P') IS NOT NULL DROP PROC PROC_PHANTOM_T2_CHUANVO
GO
CREATE PROC PROC_PHANTOM_T2_CHUANVO
	@id_agency nchar(10),
	@id_dish nchar(10),
	@unit int
AS
BEGIN TRAN
	INSERT [dbo].[MENU] ([id_agency], [id_dish], [unit], [isActive]) 
	VALUES (@id_agency, @id_dish, @unit, 1)	
COMMIT TRAN
------------------------------------------------------------------------------------------------------
--Xem toàn bộ đơn hàng
IF OBJECT_ID('PROC_PHANTOM_T1_TRUNGDUC', 'p') is not null DROP PROC PROC_PHANTOM_T1_TRUNGDUC
GO
CREATE PROC PROC_PHANTOM_T1_TRUNGDUC
	@id_agency nchar(10)
AS
BEGIN TRAN
	SELECT *
	FROM BILL b
	WHERE b.agency = @id_agency and b.isActive = 1
	WAITFOR DELAY '00:00:10'
COMMIT TRAN

--FIX
IF OBJECT_ID('PROC_PHANTOM_T1_TRUNGDUC', 'p') is not null DROP PROC PROC_PHANTOM_T1_TRUNGDUC
GO
CREATE PROC PROC_PHANTOM_T1_TRUNGDUC
	@id_agency nchar(10)
AS
BEGIN TRAN
	SELECT *
	FROM BILL b WITH (Serializable)
	WHERE b.agency = @id_agency and b.isActive = 1
	WAITFOR DELAY '00:00:10'
COMMIT TRAN 
------------------------------------------------------------------------------------------------------
--Thêm món ăn vào menu
IF OBJECT_ID('PROC_PHANTOM_T2_ANHOA', 'p') is not null DROP PROC PROC_PHANTOM_T2_ANHOA
GO
CREATE PROC PROC_PHANTOM_T2_ANHOA @idagency nchar(10), @iddish nchar(10), @unit int	
AS
BEGIN TRAN
	INSERT INTO MENU(id_agency, id_dish, unit, isActive)
	VALUES (@idagency, @iddish, @unit, 1)
COMMIT TRAN
------------------------------------------------------------------------------------------------------
--xem toàn bộ nhân viên
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

--Thêm nhân viên vào nhà hàng
IF OBJECT_ID('PROC_PHANTOM_T2_LAM', N'P') IS NOT NULL DROP PROC PROC_PHANTOM_T2_LAM
GO
CREATE PROC PROC_PHANTOM_T2_LAM
	@id_employee nchar(10),
	@name nvarchar(10),
	@gmail nvarchar(50),
	@id_card nvarchar(50),
	@position nchar(10),
	@agency nchar(10)
AS
BEGIN TRAN
	INSERT [dbo].[EMPLOYEE] ([id_employee], [name], [gmail], [id_card], [address], [position], [agency], [isActive]) 
	VALUES (@id_employee, @name, @gmail, @id_card, DBO.GET_IDADDRESS(), @position, @agency, 1)	
COMMIT TRAN

--T1 FIX
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
------------------------------------------------------------------------------------------------------
--T1 Quản lý xem danh sách món ăn theo loại
IF OBJECT_ID('PROC_PHANTOM_T1_LANG', N'P') IS NOT NULL DROP PROC PROC_PHANTOM_T1_LANG
GO
CREATE PROC PROC_PHANTOM_T1_LANG
	@id_type nchar(10),
	@user_name nchar(10)
AS
BEGIN TRAN
	SELECT * 
	FROM DISH D, TYPE_DISH T, AGENCY A, LOGIN L, EMPLOYEE E 
	WHERE D.type_dish=T.id_type_dish AND E.id_employee = L.id_owner AND E.agency = A.id_agency AND L.user_name = @user_name AND D.isActive = '1' AND D.type_dish = @id_type
	WAITFOR DELAY '00:00:15'
COMMIT TRAN
GO

--T2 Quản lý thêm món ăn
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

--T1 FIX
IF OBJECT_ID('PROC_PHANTOM_T1_LANG', N'P') IS NOT NULL DROP PROC PROC_PHANTOM_T1_LANG
GO
CREATE PROC PROC_PHANTOM_T1_LANG
	@id_type nchar(10),
	@user_name nchar(10)
AS
BEGIN TRAN
	SELECT * 
	FROM DISH D, TYPE_DISH T, AGENCY A, LOGIN L, EMPLOYEE E WITH (Serializable)
	WHERE D.type_dish=T.id_type_dish AND E.id_employee = L.id_owner AND E.agency = A.id_agency AND L.user_name = @user_name AND D.isActive = '1' AND D.type_dish = @id_type
	WAITFOR DELAY '00:00:15'
COMMIT TRAN
GO
--*************************************************************--
--Unrepeatable Read--
--*************************************************************--
--cập nhật giá món ăn
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T2_CHUAN', 'P') IS NOT NULL DROP PROC PROC_UNREPEATABLEREAD_T2_CHUAN
GO
CREATE PROC PROC_UNREPEATABLEREAD_T2_CHUAN @id_dish nchar(10), @price nvarchar(50)
AS
BEGIN TRAN
	UPDATE DISH 
	SET [price] = @price
	WHERE id_dish = @id_dish and isActive = 1 
COMMIT TRAN
------------------------------------------------------------------------------------------------------
--Quản tị viên update hình ảnh món ăn
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T2_LAM', 'P') IS NOT NULL DROP PROC PROC_UNREPEATABLEREAD_T2_LAM
GO
CREATE PROC PROC_UNREPEATABLEREAD_T2_LAM @id_dish nchar(10), @image nvarchar(50)
AS
BEGIN TRAN
	UPDATE DISH 
	SET [image] = @image
	WHERE id_dish = @id_dish and isActive = 1 
COMMIT TRAN
------------------------------------------------------------------------------------------------------
--Admin đang xem danh sách món ăn theo loại thì quản lý B xóa loại món ăn đó đi. 
--T1
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T1_LANG', N'P') IS NOT NULL DROP PROC PROC_UNREPEATABLEREAD_T1_LANG
GO
CREATE PROC PROC_UNREPEATABLEREAD_T1_LANG
	@id_type nchar(10),
	@user_name nchar(10)
AS
BEGIN TRAN
	SELECT * 
	FROM DISH D, TYPE_DISH T, AGENCY A, LOGIN L, EMPLOYEE E 
	WHERE D.type_dish=T.id_type_dish AND E.id_employee = L.id_owner AND E.agency = A.id_agency AND L.user_name = @user_name AND D.isActive = '1' AND D.type_dish = @id_type
	WAITFOR DELAY '00:00:15'

	SELECT * 
	FROM DISH D, TYPE_DISH T, AGENCY A, LOGIN L, EMPLOYEE E 
	WHERE D.type_dish=T.id_type_dish AND E.id_employee = L.id_owner AND E.agency = A.id_agency AND L.user_name = @user_name AND D.isActive = '1' AND D.type_dish = @id_type	
COMMIT TRAN
GO

--T2
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

--T1 FIX
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T1_LANG', N'P') IS NOT NULL DROP PROC PROC_UNREPEATABLEREAD_T1_LANG
GO
CREATE PROC PROC_UNREPEATABLEREAD_T1_LANG
	@id_type nchar(10),
	@user_name nchar(10)
AS
BEGIN TRAN
	SELECT * 
	FROM DISH D, TYPE_DISH T, AGENCY A, LOGIN L, EMPLOYEE E WITH (RepeatableRead)
	WHERE D.type_dish=T.id_type_dish AND E.id_employee = L.id_owner AND E.agency = A.id_agency AND L.user_name = @user_name AND D.isActive = '1' AND D.type_dish = @id_type
	WAITFOR DELAY '00:00:15'

	SELECT * 
	FROM DISH D, TYPE_DISH T, AGENCY A, LOGIN L, EMPLOYEE E 
	WHERE D.type_dish=T.id_type_dish AND E.id_employee = L.id_owner AND E.agency = A.id_agency AND L.user_name = @user_name AND D.isActive = '1' AND D.type_dish = @id_type	
COMMIT TRAN
--------------------------------------------------------------------------------------------------------------
--Quản lý cập nhật giá món ăn trên 50.000
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T2_ANHOA', 'p') is not null DROP PROC PROC_UNREPEATABLEREAD_T2_ANHOA
GO
CREATE PROC PROC_UNREPEATABLEREAD_T2_ANHOA @id_dish nchar(10), @price int
AS
BEGIN TRAN
	UPDATE DISH
	SET price = @price
	WHERE id_dish = @id_dish
COMMIT TRAN
--*************************************************************--
--Deadlock--
--*************************************************************--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


--*************************************************************--
--Các PROC tự xây dựng--
--*************************************************************--
CREATE PROC usp_GetLishDish @user_name nchar(10)
AS
BEGIN
	SELECT *
	FROM DISH D, TYPE_DISH T, AGENCY A, LOGIN L, EMPLOYEE E
	WHERE D.type_dish=T.id_type_dish AND E.id_employee = L.id_owner AND E.agency = A.id_agency AND L.user_name = @user_name AND D.isActive = '1'
END
-----------------------------------------------------------------
CREATE PROC usp_GetMenu @user_name nchar(10)
AS
BEGIN
	SELECT D.id_dish, D.dish_name, M.unit
	FROM DISH D, AGENCY A, LOGIN L, EMPLOYEE E, MENU M
	WHERE L.user_name = @user_name AND E.id_employee = L.id_owner AND E.agency = A.id_agency AND D.isActive = '1' AND M.id_dish = D.id_dish
END
-----------------------------------------------------------------
CREATE PROC usp_GetLishTypeDish
AS
BEGIN
	SELECT T.type_dish_name, T.id_type_dish
	FROM TYPE_DISH T
END
-----------------------------------------------------------------
CREATE PROC usp_GetTypeDishtoCCB @id nchar(10)
AS
BEGIN
	SELECT T.type_dish_name, T.id_type_dish
	FROM TYPE_DISH T
	WHERE T.id_type_dish = @id
END	
-----------------------------------------------------------------
CREATE FUNCTION AUTO_IDAD()
RETURNS VARCHAR(5)
AS
BEGIN
	DECLARE @ID VARCHAR(5)
	IF (SELECT COUNT(id_address) FROM ADDRESS) = 0
		SET @ID = '0'
	ELSE
		SELECT @ID = MAX(RIGHT(id_address, 7)) FROM ADDRESS
		SELECT @ID = CASE
			WHEN @ID >= 0 and @ID < 9 THEN 'ad_0' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)
			WHEN @ID >= 9 THEN 'ad_' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)
		END
	RETURN @ID
END
-----------------------------------------------------------------
CREATE PROC usp_GetMenuPay @id nchar(10)
AS
BEGIN
	SELECT *
	FROM MENU M, 
	WHERE id_agency = @id AND isActive = '1'
END
-----------------------------------------------------------------
CREATE PROC usp_GetLishAgency
AS
BEGIN
	SELECT A.agency_name
	FROM AGENCY A
END
-----------------------------------------------------------------
CREATE FUNCTION GET_IDADDRESS()
RETURNS VARCHAR(10)
AS
BEGIN
	DECLARE @id_address nchar(10)
	SELECT TOP 1 @id_address = A.id_address
	FROM ADDRESS A ORDER BY A.id_address DESC
	RETURN @id_address
END

CREATE PROC usp_AddAddress
	@number_street nvarchar(50),
	@ward nvarchar(50),
	@district nvarchar(50),
	@city nvarchar(50)
AS
	INSERT [dbo].[ADDRESS]
	VALUES (DBO.AUTO_IDAD(), @number_street, @ward, @district, @city, 1)
------------------------------------------------------------------