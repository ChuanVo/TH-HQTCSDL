USE [HuongVietRestaurant]
GO

--Lỗi DirtyRead
--Mô tả: Quản lý cập nhật số lượng của món ăn A trong MENU (chưa commit) thì khách hàng thực hiện xem MENU có chứa món ăn mà quản lý đang cập nhật.

--T1: Quản lý cập nhật số lượng món ăn có id là @id_dish thuộc chi nhánh @id_agency với số lượng là @unit
IF OBJECT_ID('PROC_DIRTYREAD_T1_ANHOA', 'p') is not null DROP PROC PROC_DIRTYREAD_T1_ANHOA
GO
CREATE PROC PROC_DIRTYREAD_T1_ANHOA @id_agency nchar(10), @id_dish nchar(10), @unit int
AS
BEGIN TRAN
	UPDATE MENU
	SET unit = @unit
	WHERE id_agency = @id_agency AND id_dish = @id_dish
	WAITFOR DELAY '00:00:15'
ROLLBACK TRAN

--T2: Khách hàng xem MENU thuộc chi nhánh @id_agency như T1 và MENU đó có chứa @id_dish mà T1 đang cập nhật
IF OBJECT_ID('PROC_DIRTYREAD_T2_ANHOA', 'p') is not null DROP PROC PROC_DIRTYREAD_T2_ANHOA
GO
CREATE PROC PROC_DIRTYREAD_T2_ANHOA @id_agency nchar(10)
AS
BEGIN TRAN
SET TRAN ISOLATION LEVEL READ UNCOMMITTED  --Đảm bảo cho việc xảy ra DirtyRead
	SELECT D.dish_name, T.type_dish_name, D.price, M.unit
	FROM MENU M, AGENCY A, DISH D, TYPE_DISH T
	WHERE A.id_agency = @id_agency AND M.id_agency = A.id_agency AND M.id_dish = D.id_dish AND D.type_dish = T.id_type_dish
COMMIT TRAN

EXEC PROC_DIRTYREAD_T2_ANHOA 'ag_1'

--Hướng dẫn thực hiện
--Bước 1: Gọi PROC thực hiện T1, cập nhật só lượng món 'dish_1' ở chi nhánh có id 'ag_1' với số lượng là 10
EXEC PROC_DIRTYREAD_T1_ANHOA 'ag_1', 'dish_1', 10
--Bước 2: Trong vòng 15 giây trễ đã cài đặt ở trên, ta gọi PROC thực hiện T2, xem danh sách món ở chi nhánh 'td_1'
EXEC PROC_DIRTYREAD_T2_ANHOA 'ag_1'
--Xem kết quả: Khi ta xem danh sách món, thì món đã được cập nhật số lượng. 
			 --Nhưng thực tế transaction ở T1 đã bị rollback nên số lượng món 'dish_1' chưa được cập nhật. Nên T2 đã đọc dữ liệu rác => Lỗi DirtyRead

--Giải quyết lỗi: Ta sử dụng mức cô lập READ COMMITTED cho T2.
IF OBJECT_ID('PROC_FIX_DIRTYREAD_ANHOA', 'p') is not null DROP PROC PROC_FIX_DIRTYREAD_ANHOA
GO
CREATE PROC PROC_FIX_DIRTYREAD_ANHOA @id_agency nchar(10)
AS
BEGIN TRAN
SET TRAN ISOLATION LEVEL READ COMMITTED  --Giải quyết lỗi DirtyRead
	SELECT D.dish_name, T.type_dish_name, D.price, M.unit
	FROM MENU M, AGENCY A, DISH D, TYPE_DISH T
	WHERE A.id_agency = @id_agency AND M.id_agency = A.id_agency AND M.id_dish = D.id_dish AND D.type_dish = T.id_type_dish
COMMIT TRAN