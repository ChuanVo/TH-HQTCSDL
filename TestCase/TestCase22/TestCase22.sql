USE HuongVietRestaurant
GO
--===============> TEST CASE 22 <==============

/*
- TestCase22: 
- Tình huống:
--Giao tác T1:
--		+ UPDATE DISH set dish_name = 'món ăn 1' where id_dish = 'X'
--		+ wait(15'')
-- 		+ UPDATE TYPE_DISH set type_name = 'loại 1' where id_type = 'P'  
--Giao tác T2:
--		+ UPDATE DISH set dish_name = 'món ăn 1' where id_dish = 'X' 
--		+ wait(15'')
-- 		+ UPDATE TYPE_DISH set type_name = 'loại 1' where id_type = 'P'  

- Hướng dẫn sử dụng: 
	+ Bước 1: Chạy TRANSACTION T1 
	+ Bước 2: Trong vòng 15 giây kể từ khi chạy TRANSACTION T1 ta chạy TRANSACTION T2
*/
--TRANSACTION 1 --
IF OBJECT_ID('PROC_DEADLOCK_T1_CHUAN', N'P') IS NOT NULL DROP PROC PROC_DEADLOCK_T1_CHUAN
GO
CREATE PROC PROC_DEADLOCK_T1_CHUAN
	@id_dish nchar(10),
	@dish_name nvarchar(50),
	@id_type_dish nchar(10),
	@type_dish_name nvarchar(50)
AS
BEGIN TRAN
	UPDATE DISH
	SET dish_name = @dish_name
	WHERE id_dish = @id_dish
	WAITFOR DELAY '00:00:10'

	UPDATE TYPE_DISH	
	SET type_dish_name = @type_dish_name
	WHERE id_type_dish = @id_type_dish
	
COMMIT TRAN




--TRANSACTION 2 --
IF OBJECT_ID('PROC_DEADLOCK_T2_CHUAN', N'P') IS NOT NULL DROP PROC PROC_DEADLOCK_T2_CHUAN
GO
CREATE PROC PROC_DEADLOCK_T2_CHUAN
	@id_dish nchar(10),
	@dish_name nvarchar(50),
	@id_type_dish nchar(10),
	@type_dish_name nvarchar(50)
AS
BEGIN TRAN
	UPDATE TYPE_DISH	
	SET type_dish_name = @type_dish_name
	WHERE id_type_dish = @id_type_dish
	WAITFOR DELAY '00:00:10'

	UPDATE DISH
	SET dish_name = @dish_name
	WHERE id_dish = @id_dish
	
COMMIT TRAN
GO



--TRANSACTION 2 FIX--
IF OBJECT_ID('PROC_DEADLOCK_T2_CHUAN', N'P') IS NOT NULL DROP PROC PROC_DEADLOCK_T2_CHUAN
GO
CREATE PROC PROC_DEADLOCK_T2_CHUAN
	@id_dish nchar(10),
	@dish_name nvarchar(50),
	@id_type_dish nchar(10),
	@type_dish_name nvarchar(50)
AS
BEGIN TRAN
	UPDATE TYPE_DISH WITH (NOLOCK) 
	SET type_dish_name = @type_dish_name
	WHERE id_type_dish = @id_type_dish
	WAITFOR DELAY '00:00:10'

	UPDATE DISH
	SET dish_name = @dish_name
	WHERE id_dish = @id_dish
	
COMMIT TRAN
GO





--T1
EXEC PROC_DEADLOCK_T1_CHUAN 'dish_1', N'Rong biet vuot dai duong', 'td_1', 'Ngon'

--T2
EXEC PROC_DEADLOCK_T2_CHUAN 'dish_1', N'Tau hu kho thit', 'td_1', 'Ngon'

--T2(FIXED)
EXEC PROC_DEADLOCK_T2_CHUAN 'dish_1', N'Rong biet vuot dai duong', 'td_1', 'Ngon'