USE HuongVietRestaurant
GO

--============> PHANTOM <==========

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

	SELECT * 
	FROM DISH 
	WHERE isActive = 1
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

	SELECT * 
	FROM DISH 
	WHERE isActive = 1
COMMIT TRAN


--Lang

--Quản lý A đang xem danh sách loại món ăntheo loai mon an 1 B thêm loại món ăn mới thuoc loai mon an 1
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

	SELECT *
	FROM DISH
	WHERE type_dish = @id_type and isActive = 1
	
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

	SELECT *
	FROM DISH
	WHERE type_dish = @id_type
	
COMMIT TRAN
GO

EXEC PROC_PHANTOM_T1_LANG N'td_1'

--TrungDuc

--Lam
--Trong khi người quản lý xem danh sách nhân viên (chưa xong) thì người quản lý khác thêm nhân viên mới vào nhà hàng.
--TRANSACTION 1--
IF OBJECT_ID('PROC_PHANTOM_T1_LAM', 'P') IS NOT NULL DROP PROC PROC_PHANTOM_T1_LAM
GO
CREATE PROC PROC_PHANTOM_T1_LAM
AS
BEGIN TRAN
	SELECT * 
	FROM EMPLOYEE with (RepeatableRead) 
	WHERE isActive = 1
	WAITFOR DELAY '00:00:15'

	SELECT * 
	FROM EMPLOYEE 
	WHERE isActive = 1
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

	SELECT * 
	FROM EMPLOYEE 
	WHERE isActive = 1
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
CREATE PROC PROC_PHANTOM_T2_ANHOA @iddish nchar(10), @typedish nchar(10), @dishname nvarchar(50), @price int, 
								  @image nvarchar(50), @isActive int, @agency nchar(10), @unit int	
AS
BEGIN TRAN
	INSERT INTO DISH(id_dish, type_dish, dish_name, price, image, isActive)
	VALUES (@iddish, @typedish, @dishname, @price, @image, @isActive)

	INSERT INTO MENU(id_agency, id_dish, unit, isActive)
	VALUES (@agency, @iddish, @unit, 1)
COMMIT TRAN
EXEC PROC_PHANTOM_T2_ANHOA 'dish_15', 'td_1', N'Bánh bao trứng muối', 15, './', 1, 'ag_1', 10

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
