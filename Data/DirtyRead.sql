USE [HuongVietRestaurant]
GO

--============> DIRTY READ <==========

--AnHoa

--Mô tả: Quản lý cập nhật số lượng của món ăn A trong MENU (chưa commit) thì khách hàng thực hiện xem MENU có chứa món ăn mà quản lý đang cập nhật.

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

EXEC PROC_DIRTYREAD_T1_ANHOA 'ag_1', 'dish_1', -1

--TRANSACTION 2:
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

--TRANSACTION 2 FIX:
IF OBJECT_ID('PROC_DIRTYREAD_T2_ANHOA', 'p') is not null DROP PROC PROC_DIRTYREAD_T2_ANHOA
GO
CREATE PROC PROC_DIRTYREAD_T2_ANHOA @id_agency nchar(10)
AS
BEGIN TRAN
SET TRAN ISOLATION LEVEL READ COMMITTED  --Giải quyết lỗi DirtyRead
	SELECT D.dish_name, T.type_dish_name, D.price, M.unit
	FROM MENU M, AGENCY A, DISH D, TYPE_DISH T
	WHERE A.id_agency = @id_agency AND M.id_agency = A.id_agency AND M.id_dish = D.id_dish AND D.type_dish = T.id_type_dish
COMMIT TRAN