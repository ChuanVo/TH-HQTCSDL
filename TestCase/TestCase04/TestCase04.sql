USE HuongVietRestaurant
GO
--===============> TEST CASE 04 <==============

/*
- TestCase04: 
- Tình huống: Quản lý cập nhật số lượng của món ăn A trong MENU (chưa commit) 
thì khách hàng thực hiện xem MENU có chứa món ăn mà quản lý đang cập nhật.
- Hướng dẫn sử dụng: 
	+ Bước 1: Chạy TRANSACTION T1 
	+ Bước 2: Trong vòng 15 giây kể từ khi chạy TRANSACTION T1 ta chạy TRANSACTION T2
*/
--TRANSACTION 1:
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


--TRANSACTION 2:
IF OBJECT_ID('PROC_DIRTYREAD_T2_ANHOA', 'p') is not null DROP PROC PROC_DIRTYREAD_T2_ANHOA
GO
CREATE PROC PROC_DIRTYREAD_T2_ANHOA @id_agency nchar(10)
AS
BEGIN TRAN
SET TRAN ISOLATION LEVEL READ UNCOMMITTED  -- Đảm bảo cho việc xảy ra DirtyRead
	SELECT M.id_agency, D.id_dish, M.unit, D.dish_name, D.type_dish, D.image, D.price
	FROM MENU M JOIN DISH D 
	ON id_agency = @id_agency AND M.id_dish = D.id_dish AND M.isActive = 1
COMMIT TRAN



--TRANSACTION 2 FIX:
IF OBJECT_ID('PROC_DIRTYREAD_T2_ANHOA', 'p') is not null DROP PROC PROC_DIRTYREAD_T2_ANHOA
GO
CREATE PROC PROC_DIRTYREAD_T2_ANHOA @id_agency nchar(10)
AS
BEGIN TRAN
SET TRAN ISOLATION LEVEL READ COMMITTED  --Giải quyết lỗi DirtyRead
	SELECT M.id_agency, D.id_dish, M.unit, D.dish_name, D.type_dish, D.image, D.price
	FROM MENU M JOIN DISH D 
	ON id_agency = @id_agency AND M.id_dish = D.id_dish AND M.isActive = 1
COMMIT TRAN


--T1
EXEC PROC_DIRTYREAD_T1_ANHOA 'ag_1', 'dish_1', -1

--T2(ERROR)
EXEC PROC_DIRTYREAD_T2_ANHOA 'ag_1'

--T2(FIXED)
EXEC PROC_DIRTYREAD_T2_ANHOA 'ag_1'