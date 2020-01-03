USE HuongVietRestaurant
GO
--===============> TEST CASE 13 <==============

/*
- TestCase13: 
- Tình huống: Khách hàng đang xem danh sách thuộc loại món A, thì quản lý thêm món thuộc loại món A vào.
- Hướng dẫn sử dụng: 
	+ Bước 1: Chạy TRANSACTION T1 
	+ Bước 2: Trong vòng 15 giây kể từ khi chạy TRANSACTION T1 ta chạy TRANSACTION T2
*/
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

--T1
EXEC PROC_PHANTOM_T1_ANHOA 'ag_1'

--T2(ERROR)
EXEC PROC_PHANTOM_T2_ANHOA 'ag_2', 'dish_3', 20

--T1(FIXED)
EXEC PROC_PHANTOM_T1_ANHOA 'ag_1'