USE HuongVietRestaurant
GO

--============> PHANTOM <==========

--ChuanVo
--Trong khi Khách hàng xem danh sách món ăn thì người quản lí chèn thêm món ăn vao menu.
--TRANSACTION 1--
IF OBJECT_ID('PROC_PHANTOM_T1_CHUANVO', 'P') IS NOT NULL DROP PROC PROC_PHANTOM_T1_CHUANVO 
GO 
CREATE PROC PROC_PHANTOM_T1_CHUANVO @id_agency nchar(10)
AS
BEGIN TRAN

	SELECT M.id_agency, D.id_dish, M.unit, D.dish_name, D.type_dish, D.image, D.price
	FROM MENU M JOIN DISH D with (RepeatableRead)
	ON id_agency = @id_agency AND M.id_dish = D.id_dish AND M.isActive =1

	WAITFOR DELAY '00:00:15'
COMMIT TRAN

--TRANSACTION 2
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

--FIX => TRANSACTION 1--
IF OBJECT_ID('PROC_PHANTOM_T1_CHUANVO', 'P') IS NOT NULL DROP PROC PROC_PHANTOM_T1_CHUANVO
GO
CREATE PROC PROC_PHANTOM_T1_CHUANVO @id_agency nchar(10)
AS
BEGIN TRAN

	SELECT M.id_agency, D.id_dish, M.unit, D.dish_name, D.type_dish, D.image, D.price
	FROM MENU M JOIN DISH D with (Serializable)
	ON id_agency = @id_agency AND M.id_dish = D.id_dish AND M.isActive =1

	--WAITFOR DELAY '00:00:15'

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
	FROM EMPLOYEE
	WHERE isActive = 1
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
CREATE PROC PROC_PHANTOM_T1_ANHOA @id_agency nchar(10), @type_dish nchar(10)
AS
BEGIN TRAN
	SELECT M.id_agency, D.id_dish, M.unit, D.dish_name, D.type_dish, D.image, D.price
	FROM MENU M JOIN DISH D
	ON id_agency = @id_agency AND M.id_dish = D.id_dish AND M.isActive = 1 AND D.type_dish = @type_dish
	--WAITFOR DELAY '00:00:15'
COMMIT 

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
CREATE PROC PROC_PHANTOM_T1_ANHOA @id_agency nchar(10), @type_dish nchar(10)
AS
BEGIN TRAN
SET TRAN ISOLATION LEVEL SERIALIZABLE  --Giải quyết lỗi Phantom
	SELECT M.id_agency, D.id_dish, M.unit, D.dish_name, D.type_dish, D.image, D.price
	FROM MENU M JOIN DISH D
	ON id_agency = @id_agency AND M.id_dish = D.id_dish AND M.isActive = 1 AND D.type_dish = @type_dish
	WAITFOR DELAY '00:00:15'
COMMIT TRAN
EXEC PROC_PHANTOM_T1_ANHOA 'ag_1'



--TrungDuc

--LỖI PHANTOM
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


