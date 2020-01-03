USE HuongVietRestaurant
GO
--===============> TEST CASE 09 <==============

/*
- TestCase09: 
- Tình huống: Admin 1 đang thực hiện update tên của món ăn dish_1 trong bảng món ăn (chưa commit), 
thì Admin 2 update tên món ăn dish_1 trong bảng DISH.
- Hướng dẫn sử dụng: 
	+ Bước 1: Chạy TRANSACTION T1 
	+ Bước 2: Trong vòng 15 giây kể từ khi chạy TRANSACTION T1 ta chạy TRANSACTION T2
*/
--T1: Admin thực hiện update loại món ăn
IF OBJECT_ID('PROC_LOSTUPDATE_T1_TRUNGDUC', 'p') is not null DROP PROC PROC_LOSTUPDATE_T1_TRUNGDUC
GO
CREATE PROC PROC_LOSTUPDATE_T1_TRUNGDUC
	@id_dish nchar(10),
	@name nchar(50)
AS
BEGIN TRAN
	SELECT *
	FROM DISH d 
	WHERE id_dish = @id_dish and isActive = 1
	WAITFOR DELAY '00:00:10'
	
	UPDATE DISH 
	SET dish_name = @name
	WHERE id_dish = @id_dish and isActive = 1

COMMIT TRAN
GO


--T2: Admin 2 update món ăn dish_1 trong bảng DISH 
IF OBJECT_ID('PROC_LOSTUPDATE_T2_TRUNGDUC', 'p') is not null DROP PROC PROC_LOSTUPDATE_T2_TRUNGDUC
GO
CREATE PROC PROC_LOSTUPDATE_T2_TRUNGDUC
	@id_dish nchar(10),
	@name nchar(50)
AS
BEGIN TRAN
	SELECT *
	FROM DISH d 
	WHERE id_dish = @id_dish and isActive = 1

	UPDATE DISH 
	SET dish_name = @name
	WHERE id_dish = @id_dish and isActive = 1
COMMIT TRAN
GO


--T2 FIX: Admin 2 update món ăn dish_1 trong bảng DISH 
IF OBJECT_ID('PROC_LOSTUPDATE_T2_TRUNGDUC', 'p') is not null DROP PROC PROC_LOSTUPDATE_T2_TRUNGDUC
GO
CREATE PROC PROC_LOSTUPDATE_T2_TRUNGDUC
	@id_dish nchar(10),
	@name nchar(50)
AS
BEGIN TRAN
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
	SELECT *
	FROM DISH d 
	WHERE id_dish = @id_dish and isActive = 1

	UPDATE DISH 
	SET dish_name = @name
	WHERE id_dish = @id_dish and isActive = 1
COMMIT TRAN
GO


--T1(ERROR)
EXEC PROC_LOSTUPDATE_T1_TRUNGDUC N'dish_2', N'bun mac qua roi'

--T2
EXEC PROC_LOSTUPDATE_T2_TRUNGDUC N'dish_2', N'bun bla bla bla'

--T2(FIXED)
EXEC PROC_LOSTUPDATE_T2_TRUNGDUC N'dish_2', N'bun bla bla bla'