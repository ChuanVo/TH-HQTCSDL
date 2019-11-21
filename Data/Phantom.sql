USE HuongVietRestaurant
GO

--============> PHANTOM <==========

--ChuanVo

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
USE HuongVietRestaurant
GO

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

	SELECT *
	FROM BILL b1
	WHERE b1.agency = @id_agency and b1.isActive = 1

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

	SELECT *
	FROM BILL b1
	WHERE b1.agency = @id_agency and b1.isActive = 1

COMMIT TRAN 

EXEC PROC_PHANTOM_T1_TRUNGDUC N'ag_2'
--DangLam

