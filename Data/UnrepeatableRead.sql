USE HuongVietRestaurant
GO

--============> UNREPEATABLE READ <==========

--ChuanVo

--Lang
--Admin đang xem danh sách món ăn theo loại 
--thì quản lý B xóa loại món ăn đó đi. 
--TRANSACTION 1--
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T1_LANG', N'P') IS NOT NULL DROP PROC PROC_UNREPEATABLEREAD_T1_LANG
GO
CREATE PROC PROC_UNREPEATABLEREAD_T1_LANG
	@id_type nchar(10)
AS
BEGIN TRAN
	SELECT Count(*) 
	FROM DISH d, TYPE_DISH td
	WHERE d.type_dish = @id_type and d.type_dish = td.id_type_dish and td.isActive = 1 and d.isActive = 1
	WAITFOR DELAY '00:00:15'

	SELECT *
	FROM DISH d1, TYPE_DISH td1
	WHERE d1.type_dish = @id_type and d1.type_dish = td1.id_type_dish and td1.isActive = 1 and d1.isActive = 1
	
COMMIT TRAN
GO

EXEC PROC_UNREPEATABLEREAD_T1_LANG N'td_1'

  --TRANSACTION 2--
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T2_LANG', N'P') IS NOT NULL DROP PROC PROC_UNREPEATABLEREAD_T2_LANG
GO
CREATE PROC PROC_UNREPEATABLEREAD_T2_LANG
	@id_type nchar(10)
AS
BEGIN TRAN
	UPDATE TYPE_DISH 
	SET isActive = 0
	WHERE id_type_dish = @id_type and isActive = 1 
COMMIT TRAN
GO

EXEC PROC_UNREPEATABLEREAD_T2_LANG N'td_1'

--TRANSACTION 1 FIX --
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T1_LANG', N'P') IS NOT NULL DROP PROC PROC_UNREPEATABLEREAD_T1_LANG
GO
CREATE PROC PROC_UNREPEATABLEREAD_T1_LANG
	@id_type nchar(10)
AS
BEGIN TRAN
	SELECT Count(*) 
	FROM DISH d, TYPE_DISH td WITH (RepeatableRead)
	WHERE d.type_dish = @id_type and d.type_dish = td.id_type_dish and td.isActive = 1 and d.isActive = 1
	WAITFOR DELAY '00:00:10'

	SELECT *
	FROM DISH d1, TYPE_DISH td1
	WHERE d1.type_dish = @id_type and d1.type_dish = td1.id_type_dish and td1.isActive = 1 and d1.isActive = 1
	
COMMIT TRAN
GO

EXEC PROC_UNREPEATABLEREAD_T1_LANG N'td_1'

--AnHoa


--TrungDuc
--Khách A xem danh sách các món ăn tại chi nhánh 1 có  SL >=1,
-- khách B mua hết 1 món trong đó ( update SL =0)

--TRANSACTION 1--
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T1_TRUNGDUC', N'P') IS NOT NULL DROP PROC PROC_UNREPEATABLEREAD_T1_TRUNGDUC
GO
CREATE PROC PROC_UNREPEATABLEREAD_T1_TRUNGDUC
	@id_agency nchar(10)
AS
BEGIN TRAN
	SELECT mn.id_agency, COUNT(*) 
	FROM MENU mn
	WHERE mn.id_agency = @id_agency and mn.isActive = 1
	GROUP BY mn.id_agency
	HAVING COUNT(*) >= 1
	WAITFOR DELAY '00:00:0'

	SELECT *
	FROM MENU mn1
	WHERE mn1.id_agency = @id_agency and mn1.isActive = 1 and mn1.unit >= 1
	
COMMIT TRAN
GO

EXEC PROC_UNREPEATABLEREAD_T1_TRUNGDUC N'ag_1'

 --TRANSACTION 2--
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T2_TRUNGDUC', N'P') IS NOT NULL DROP PROC PROC_UNREPEATABLEREAD_T2_TRUNGDUC
GO
CREATE PROC PROC_UNREPEATABLEREAD_T2_TRUNGDUC
	@id_agency nchar(10),
	@id_dish nchar(10),
	@unit int
AS
BEGIN TRAN
	UPDATE MENU
	SET unit = unit - @unit
	WHERE id_agency = @id_agency and isActive = 1 and id_dish = @id_dish
COMMIT TRAN
GO

EXEC PROC_UNREPEATABLEREAD_T2_TRUNGDUC N'ag_1', N'dish_2', 26
GO
--TRANSACTION 1 FIX--
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T1_TRUNGDUC', N'P') IS NOT NULL DROP PROC PROC_UNREPEATABLEREAD_T1_TRUNGDUC
GO
CREATE PROC PROC_UNREPEATABLEREAD_T1_TRUNGDUC
	@id_agency nchar(10)
AS
BEGIN TRAN
	SELECT mn.id_agency, COUNT(*) 
	FROM MENU mn WITH (RepeatableRead)
	WHERE mn.id_agency = @id_agency and mn.isActive = 1
	GROUP BY mn.id_agency
	HAVING COUNT(*) >= 1
	WAITFOR DELAY '00:00:0'

	SELECT *
	FROM MENU mn1
	WHERE mn1.id_agency = @id_agency and mn1.isActive = 1 and mn1.unit >= 1
	
COMMIT TRAN
GO

EXEC PROC_UNREPEATABLEREAD_T1_TRUNGDUC N'ag_1'

--DangLam

