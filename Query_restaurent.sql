USE HuongVietRestaurant
GO


--ten nhan vien, email nhan vien, them nhan vien vao nha hang, 

---------------------------
CREATE PROC usp_GetLishDish @user_name nchar(10)
AS
BEGIN
	SELECT *
	FROM DISH D, TYPE_DISH T, AGENCY A, LOGIN L, EMPLOYEE E
	WHERE D.type_dish=T.id_type_dish AND E.id_employee = L.id_owner AND E.agency = A.id_agency AND L.user_name = @user_name AND D.isActive = '1'
END

---------------------------

CREATE PROC usp_GetLishTypeDish
AS
BEGIN
	SELECT T.type_dish_name, T.id_type_dish
	FROM TYPE_DISH T
END

----------------------------------------------------------------------------

CREATE PROC usp_GetTypeDishtoCCB @id nchar(10)
AS
BEGIN
	SELECT T.type_dish_name, T.id_type_dish
	FROM TYPE_DISH T
	WHERE T.id_type_dish = @id
END
	
--------------------------------------------------------------------
--------------------------------------------------------------------
--------------------------------------------------------------------
--------------------------------------------------------------------
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

------------------------------------------------------------------------
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

------------------------------------------------------------------
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

---------------------------------------------------------------------------------
--cập nhật tên món ăn
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
-------------------------------------------------------------------------------------
--thêm món ăn
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
--------------------------------------------------------------------------------
--xóa món ăn
CREATE PROC PROC_DelDish
	@id_dish nchar(10)
AS
BEGIN TRAN
	UPDATE DISH 
	SET isActive = 0
	WHERE id_dish = @id_dish and isActive = 1 
COMMIT TRAN
----------------------------------------------------------------------------------
--xem danh sách món ăn theo loại
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
-----------------------------------------------------------------------------------
--xóa loại món ăn
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T2_LANG', N'P') IS NOT NULL DROP PROC PROC_UNREPEATABLEREAD_T2_LANG
GO
CREATE PROC PROC_UNREPEATABLEREAD_T2_LANG
	@id_type_dish nchar(10)
AS
BEGIN TRAN
	UPDATE TYPE_DISH 
	SET isActive = 0
	WHERE id_type_dish = @id_type_dish and isActive = 1 
COMMIT TRAN
GO
-------------------------------------------------------------------
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
----------------------------------------------------------------------------
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
------------------------------------------------------------------------------------
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
-----------------------------------------------------------------------------------------















-------------------------------------------------------------------------------------
--xem danh sách món ăn theo loại //còn lỗi
IF OBJECT_ID('PROC_PHANTOM_T1_LANG', N'P') IS NOT NULL DROP PROC PROC_PHANTOM_T1_LANG
GO
CREATE PROC PROC_PHANTOM_T1_LANG
	@id_type nchar(10),
	@user_name nchar(10)
AS
BEGIN TRAN 
	SELECT D.id_dish, D.dish_name, D.price, T.type_dish_name, D.image, M.unit, A.agency_name, M.id_agency, T.id_type_dish
	FROM DISH D, TYPE_DISH T, MENU M, AGENCY A, LOGIN L, EMPLOYEE E
	WHERE D.type_dish=T.id_type_dish AND M.id_dish=D.id_dish AND A.id_agency=M.id_agency
	      AND M.id_agency = E.agency AND E.id_employee = L.id_owner AND L.user_name = @user_name
		  AND D.type_dish = @id_type AND D.isActive = 1
	--WAITFOR DELAY '00:00:2'
COMMIT TRAN
GO
SELECT D.id_dish, D.dish_name, D.price, T.type_dish_name, D.image, M.unit, A.agency_name, M.id_agency, T.id_type_dish FROM DISH D, TYPE_DISH T, MENU M, AGENCY A, LOGIN L, EMPLOYEE E WHERE D.type_dish=T.id_type_dish AND M.id_dish=D.id_dish AND A.id_agency=M.id_agency AND M.id_agency = E.agency AND E.id_employee = L.id_owner AND L.user_name = 'admin1' AND D.type_dish = 'td_1      ' AND D.isActive = 1

EXEC PROC_PHANTOM_T1_LANG 'td_1      ' , 'admin1'

--------------------------------------------------------------------------------------------

IF OBJECT_ID('PROC_PHANTOM_T1_LANG', N'P') IS NOT NULL DROP PROC PROC_PHANTOM_T1_LANG
GO
CREATE PROC PROC_PHANTOM_T1_LANG
	@id_type nchar(10)
AS
BEGIN TRAN
	SELECT *
	FROM DISH
	WHERE type_dish = @id_type and isActive = 1
	--WAITFOR DELAY '00:00:15'
COMMIT TRAN
GO




















CREATE PROC usp_GetLishAgency
AS
BEGIN
	SELECT A.agency_name
	FROM AGENCY A
END

EXEC usp_GetLishAgency

---------------------------
CREATE PROC usp_AddDish
	@id_dish nchar(10),
	@type_dish_name nvarchar(50),
	@dish_name nvarchar(50),
	@price int,
	@image nvarchar(50),
	@unit int,
	@agency nvarchar(50)
AS
BEGIN
	--lay id cua type_dish
	DECLARE @id_type_dish nchar(10)
	SELECT @id_type_dish = T.id_type_dish
	FROM TYPE_DISH T
	WHERE T.type_dish_name = N'Món khô'
	--WHERE T.type_dish_name = @type_dish_name
	--them mon an
	INSERT INTO DISH (id_dish, type_dish, dish_name, price, image, isActive) VALUES (@id_dish, @id_type_dish, @dish_name, @price, @image, '1')
	--lay id cua nha hang
	--DECLARE @id_agency nchar(10)
	--SELECT @id_agency = A.id_agency
	--FROM AGENCY A
	--WHERE A.agency_name = N''+ @agency
	--lay id cua mon an vua them
	--DECLARE @id_dish nchar(10)
	--SELECT TOP 1 @id_dish = D.id_dish FROM DISH D ORDER BY D.id_dish DESC
	--them mon an vao menu
	INSERT INTO MENU (id_agency, id_dish, unit, isActive) VALUES ('ag_1', @id_dish, @unit, '1')
END



-------------------------------
CREATE PROC usp_UpdateDish
	@id_dish nchar(10),
	@type_dish_name nvarchar(50),
	@dish_name nvarchar(50),
	@price int,
	@image nvarchar(50),
	@unit int
AS
BEGIN
--Update Dish
	UPDATE DISH SET dish_name = @dish_name, price = @price, type_dish = 'td_1', image = @image WHERE id_dish = @id_dish
--Update Menu
	UPDATE MENU SET unit = @unit WHERE id_dish = @id_dish AND id_agency = 'ag_1'
END


------------------------------
CREATE PROC usp_DeleteDish @id_dish nchar(10)
AS
BEGIN
	DELETE MENU WHERE id_dish = @id_dish AND id_agency = 'ag_1'
	DELETE DISH WHERE id_dish = @id_dish
END


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

exec PROC_DIRTYREAD_T1_CHUANVO











--Quản lý cập nhât tên nhân viên nhưng chưa commit thì quản lý khác vào xem thông tin nhân viên.
--Quản lý cập nhật giá tiền món ăn (DISH) nhưng chưa commit thì khách hàng vào xem thông tin món ăn.
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
--Quản lý cập nhật hình ảnh món ăn (DISH) nhưng chưa commit thì khách hàng vào xem thông tin món ăn.
--Quản lý cập nhật số lượng của món ăn trong MENU nhưng chưa commit thì khách hàng vào xem thông tin menu của cửa hàng
--Quản lý cập nhật thông tin email của nhân viên nhưng chưa commit thì quản lý khác xem thông tin của nhân viên.
--Người quản lý A cập nhật giá của Phở bò (chưa commit) thì người quản lý B cũng cập nhật giá của món Phở bò.
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
--Người quản lý A cập nhật tình trạng của đơn hàng D (chưa commit) thì người quản lý B cũng cập nhật tình trạng của đơn hàng D. (2 quản lí cùng thuộc 1 chi nhánh)
--Khách hàng A thực hiện mua món X (chưa commit) thì khách hàng B thực hiện mua món X.
--Admin 1 đang thực hiện update tên của món ăn dish_1 trong bảng món ăn (chưa commit), thì Admin 2 Xóa  món ăn dish_1 trong bảng DISH
--Admin nhà hàng đang cập nhật số lượng món Phở bò tại chi nhánh 1 tăng lên 5(chưa commit), trong khi đó User cũng mua món Phở bò (update số lượng món phở tại chi nhánh 1).
--Khách hàng xem toàn bộ món ăn của cửa hàng A (chưa xong) thì người quản lý thêm món ăn vào menu.
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
--Người quản lý A xem toàn bộ đơn hàng tại 1 chi nhánh(chưa xong) thì có đơn hàng mới được tạo tại chi nhánh đó
--Khách hàng đang tìm kiếm danh sách món ăn thuộc loại A (chưa xong) ở chi nhánh 1 thì trong lúc đó quản lý thêm một món thuộc loại A vào chi nhánh 1.
--Người quản lí xem danh sách nhân viên (chưa xong) thì người quản lý khác thêm nhân viên vào nhà hàng.
--Quản lý A đang xem danh sách món ăn theo loại thì quản lý B thêm món ăn mới của loại đó vào 
--Khách hàng đang xem thông tin bún bò nhưng chưa commit thì quản trị viên update thông tin giá của món bún bò.
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T2_CHUAN', 'P') IS NOT NULL DROP PROC PROC_UNREPEATABLEREAD_T2_CHUAN
GO
CREATE PROC PROC_UNREPEATABLEREAD_T2_CHUAN @id_dish nchar(10), @price nvarchar(50)
AS
BEGIN TRAN
	UPDATE DISH 
	SET [price] = @price
	WHERE id_dish = @id_dish and isActive = 1 
COMMIT TRAN

--Khách hàng đang xem thông tin bún bò nhưng chưa commit thì quản trị viên update hình ảnh của món bún bò.
--Admin đang xem danh sách món ăn theo loại thì quản lý B xóa loại món ăn đó đi. 
--Khách hàng tìm kiếm danh sách các món dưới 50.000 tại chi nhánh 1 thì Quản lý cập nhật giá món có trong chi nhánh 1 và giá dưới 50.000 thành giá trên 50.000 khiến món đó không còn trong danh sách mà khách hàng tìm kiếm nữa