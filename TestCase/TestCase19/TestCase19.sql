USE HuongVietRestaurant
GO
--===============> TEST CASE 19 <==============

/*
- TestCase19: 
- Tình huống: Quản lý đang xem danh sách món ăn theo loại thì quản lý khác xoá loại món ăn đó đi.
- Hướng dẫn sử dụng: 
	+ Bước 1: Chạy TRANSACTION T1 
	+ Bước 2: Trong vòng 15 giây kể từ khi chạy TRANSACTION T1 ta chạy TRANSACTION T2
*/
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




--T1
EXEC PROC_UNREPEATABLEREAD_T1_LANG N'td_1'

--T2
EXEC PROC_UNREPEATABLEREAD_T2_LANG N'td_1'

--T1(FIXED)
EXEC PROC_UNREPEATABLEREAD_T1_LANG N'td_1'