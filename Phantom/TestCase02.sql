USE [HuongVietRestaurant]
GO 

--Lỗi Phantom
--Mô tả: Khách hàng đang xem danh sách thuộc loại món A, thì quản lý thêm món thuộc loại món A vào.

--T1: Khách hàng xem danh sách các món thuộc loại @id_td thuộc chi nhánh @id_agency
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

--T2: Quản lý thực hiện thêm món
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

--Hướng dẫn thực hiện
--Bước 1: Gọi PROC thực hiện T1, xem danh sách món thuộc loại td_1 và chi nhánh ag_1
EXEC PROC_PHANTOM_T1_ANHOA 'td_1', 'ag_1'
--Bước 2: Trong vòng 15 giây trễ đã cài đặt ở trên, ta gọi PROC thực hiện T2, thêm món thuộc loại td_1 và chi nhánh ag_1
EXEC PROC_PHANTOM_T2_ANHOA 'dish_15', 'td_1', N'Bánh bao trứng muối', 15, './', 1, 'ag_1', 10
--Xem kết quả: Khi T1 xem danh sách món loại td_1 ở chi nhánh ag_1, thông thời gian trễ 15s thì T2 thêm món loại td_2 và chi nhánh ag_1. 
             --Hết thời gian trễ danh sách hiển thị không tồn tại món mà T2 thêm vào mặc dù trong db có tồn tại => lỗi Phantom

--Giải quyết lỗi: Ta sử dụng mức cô lập SERIALIZABLE cho T1.
 IF OBJECT_ID('PROC_FIX_PHANTOM__ANHOA', 'p') is not null DROP PROC PROC_FIX_PHANTOM__ANHOA
GO
CREATE PROC PROC_FIX_PHANTOM__ANHOA @id_td nchar(10), @id_agency nchar(10)
AS
BEGIN TRAN
SET TRAN ISOLATION LEVEL SERIALIZABLE  --Giải quyết lỗi Phantom
	SELECT D.id_dish, D.dish_name, T.type_dish_name, A.agency_name, M.unit
	FROM DISH D, AGENCY A, MENU M, TYPE_DISH T
	WHERE T.id_type_dish = @id_td AND T.id_type_dish = D.type_dish AND M.id_dish = D.id_dish AND M.id_agency = A.id_agency
	WAITFOR DELAY '00:00:15'
COMMIT TRAN