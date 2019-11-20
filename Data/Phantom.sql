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

--TRANSACTION 2
IF OBJECT_ID('PROC_PHANTOM_T2_CHUANVO', N'P') IS NOT NULL DROP PROC PROC_PHANTOM_T2_CHUANVO
GO
CREATE PROC PROC_PHANTOM_T2_CHUANVO
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

--FIX => TRANSACTION 1--
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
--AnHoa


--TrungDuc

--DangLam

