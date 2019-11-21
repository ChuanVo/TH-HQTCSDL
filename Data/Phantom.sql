USE [HuongVietRestaurant]
GO

--============> PHANTOM <==========

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
