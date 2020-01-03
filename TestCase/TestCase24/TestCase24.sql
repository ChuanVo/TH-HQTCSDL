USE HuongVietRestaurant
GO
--===============> TEST CASE 24 <==============


-- TestCase24: 
-- Tình huống:
--Giao tác T1:
--		+ SELECT * from TYPE_DISH where id_type_dish = '01'
--		+ wait(5")
-- 		+ UPDATE TYPE_DISH set type_dish_name = 'loại món gì đó ?' where id_type_dish = '01'  
--Giao tác T2:
--		+ SELECT * from TYPE_DISH where id_type_dish = '01'
--		+ wait(15'')
-- 		+ UPDATE TYPE_DISH set dish_name = 'loại món mặn chằng' where id_type_dish = '01' 

/* Hướng dẫn sử dụng: 
	+ Bước 1: Chạy TRANSACTION T1 
	+ Bước 2: Trong vòng 15 giây kể từ khi chạy TRANSACTION T1 ta chạy TRANSACTION T2
*/
--TRANSACTION 1 --
IF OBJECT_ID('PROC_DEADLOCK_T1_LAM', N'P') IS NOT NULL DROP PROC PROC_DEADLOCK_T1_LAM
GO
CREATE PROC PROC_DEADLOCK_T1_LAM
	@id_type_dish nchar(10),
	@type_dish_name nvarchar(50)
AS
BEGIN TRAN
	SELECT * 
	FROM TYPE_DISH
	WHERE id_type_dish = @id_type_dish
	WAITFOR DELAY '00:00:10'

	UPDATE TYPE_DISH	
	SET type_dish_name = @type_dish_name
	WHERE id_type_dish = @id_type_dish
	
COMMIT TRAN




--TRANSACTION 2 --
IF OBJECT_ID('PROC_DEADLOCK_T2_LAM', N'P') IS NOT NULL DROP PROC PROC_DEADLOCK_T2_LAM
GO
CREATE PROC PROC_DEADLOCK_T2_LAM
	@id_type_dish nchar(10),
	@type_dish_name nvarchar(50)
AS
BEGIN TRAN
	UPDATE TYPE_DISH	
	SET type_dish_name = @type_dish_name
	WHERE id_type_dish = @id_type_dish
	WAITFOR DELAY '00:00:10'

	SELECT * 
	FROM TYPE_DISH
	WHERE id_type_dish = @id_type_dish
	
COMMIT TRAN
GO



--TRANSACTION 2 FIX--
IF OBJECT_ID('PROC_DEADLOCK_T2_LAM', N'P') IS NOT NULL DROP PROC PROC_DEADLOCK_T2_LAM
GO
CREATE PROC PROC_DEADLOCK_T2_LAM
	@id_type_dish nchar(10),
	@type_dish_name nvarchar(50)
AS
BEGIN TRAN
	UPDATE TYPE_DISH WITH (NOLOCK) 
	SET type_dish_name = @type_dish_name
	WHERE id_type_dish = @id_type_dish
	WAITFOR DELAY '00:00:10'

	SELECT * 
	FROM TYPE_DISH
	WHERE id_type_dish = @id_type_dish
	
COMMIT TRAN
GO



--T1
EXEC PROC_DEADLOCK_T1_LAM 'td_1', N'Mon ngon'

--T2
EXEC PROC_DEADLOCK_T2_LAM 'td_1', N'Mon man'

--T2(FIXED)
EXEC PROC_DEADLOCK_T2_LAM 'td_1', N'Mon man'