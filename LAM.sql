USE HuongVietRestaurant
GO

-- DIRTY READ
-- Mô tả: Quản lý thay đổi loại món ăn của 1 món trong DISH nhưng chưa commit thì khách hàng vào xem thông tin món ăn

-- T1: Quản lý cập nhật loại món ăn @type_dish của món có id là @id_dish
IF OBJECT_ID('PROC_DIRTYREAD_T1_LAM', 'p') IS NOT NULL DROP PROC PROC_DIRTYREAD_T1_LAM
GO
CREATE PROC PROC_DIRTYREAD_T1_LAM @id_dish nchar(10), @type_dish nchar(10)
AS
BEGIN TRAN
	UPDATE DISH
	SET type_dish = @type_dish
	WHERE id_dish = @id_dish
	WAITFOR DELAY '00:00:15'
ROLLBACK TRAN

-- T2: Khách hàng vào xem thông tin món ăn có id là @id_dish được cập nhật ở T1
IF OBJECT_ID('PROC_DIRTYREAD_T2_LAM', 'p') IS NOT NULL DROP PROC PROC_DIRTYREAD_T2_LAM
GO
CREATE PROC PROC_DIRTYREAD_T2_LAM @id_dish nchar(10)
AS
BEGIN TRAN
SET TRAN ISOLATION LEVEL READ UNCOMMITTED  
	SELECT DISH.dish_name, TYPE_DISH.type_dish_name
	FROM DISH, TYPE_DISH
	WHERE  DISH.id_dish = @id_dish AND DISH.type_dish = TYPE_DISH.id_type_dish
COMMIT TRAN

EXEC PROC_DIRTYREAD_T2_LAM 'dish_1'

-- Hướng dẫn thực hiện
-- 1. Cập nhật type_dish của món có id 'dish_1' thành 'td_2' trong PROC thực hiện T1
EXEC PROC_DIRTYREAD_T1_LAM 'dish_1', 'td_2'

-- 2. Trong 15 giây trễ gọi T2
EXEC PROC_DIRTYREAD_T2_LAM 'dish_1'

-- Kết quả: T2 đọc dirty read type_dish của 'dish_1' vẫn là 'td_1'
IF OBJECT_ID('PROC_FIX_DIRTYREAD_LAM', 'p') IS NOT NULL DROP PROC PROC_FIX_DIRTYREAD_LAM
GO
CREATE PROC PROC_FIX_DIRTYREAD_LAM @id_dish nchar(10)
AS
BEGIN TRAN
SET TRAN ISOLATION LEVEL READ COMMITTED  
	SELECT DISH.dish_name, TYPE_DISH.type_dish_name
	FROM DISH, TYPE_DISH
	WHERE  DISH.id_dish = @id_dish AND DISH.type_dish = TYPE_DISH.id_type_dish
COMMIT TRAN

-- Lost update
-- Mô tả: Món X trong kho chỉ còn 1 phần. 
--Khách A xem menu hiển thị SL = 1, khách B cũng thấy SL = 1. 
--A đặt món và thanh toán, sau đó B cũng đặt món và thanh toán. 

-- T1: Khách A xem menu hiển thị món có SL = 1, đặt món
IF OBJECT_ID ('PROC_LASTUPDATE_T1_LAM', 'P') IS NOT NULL DROP PROC PROC_LASTUPDATE_T1_LAM
GO
CREATE PROC PROC_LASTUPDATE_T1_LAM 
			@id_dish nchar(10),
			@id_agency nchar(10)
AS
BEGIN TRAN

	SELECT *
	FROM MENU
	WHERE id_dish = @id_dish AND id_agency = @id_agency
	WAITFOR DELAY '00:00:15'

	UPDATE MENU
	SET unit = unit -1
	WHERE id_dish = @id_dish AND id_agency = @id_agency
COMMIT TRAN
GO

EXEC PROC_LASTUPDATE_T1_LAM 'dish_1', 'ag_1'


-- T2:
IF OBJECT_ID ('PROC_LASTUPDATE_T2_LAM', 'P') IS NOT NULL DROP PROC PROC_LASTUPDATE_T2_LAM
GO
CREATE PROC PROC_LASTUPDATE_T2_LAM 
			@id_dish nchar(10),
			@id_agency nchar(10)
AS
BEGIN TRAN

	SELECT *
	FROM MENU
	WHERE id_dish = @id_dish AND id_agency = @id_agency

	UPDATE MENU
	SET unit = unit -1
	WHERE id_dish = @id_dish AND id_agency = @id_agency
COMMIT TRAN
GO

EXEC PROC_LASTUPDATE_T2_LAM 'dish_1', 'ag_1'

-- FIX
IF OBJECT_ID ('PROC_LASTUPDATE_T2_LAM', 'P') IS NOT NULL DROP PROC PROC_LASTUPDATE_T2_LAM
GO
CREATE PROC PROC_LASTUPDATE_T2_LAM 
			@id_dish nchar(10),
			@id_agency nchar(10)
AS
BEGIN TRAN
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
	SELECT *
	FROM MENU
	WHERE id_dish = @id_dish AND id_agency = @id_agency

	UPDATE MENU
	SET unit = unit -1
	WHERE id_dish = @id_dish AND id_agency = @id_agency
COMMIT TRAN
GO

EXEC PROC_LASTUPDATE_T2_LAM 'dish_1', 'ag_1'

