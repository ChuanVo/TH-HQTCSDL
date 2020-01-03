USE HuongVietRestaurant
GO
--===============> TEST CASE 11 <==============

/*
- TestCase11: 
- Tình huống:Trong khi Khách hàng xem danh sách món ăn thì người quản lí chèn thêm món ăn vao menu.
- Hướng dẫn sử dụng: 
	+ Bước 1: Chạy TRANSACTION T1 
	+ Bước 2: Trong vòng 15 giây kể từ khi chạy TRANSACTION T1 ta chạy TRANSACTION T2
*/
--TRANSACTION 1--
IF OBJECT_ID('PROC_PHANTOM_T1_CHUANVO', 'P') IS NOT NULL DROP PROC PROC_PHANTOM_T1_CHUANVO 
GO 
CREATE PROC PROC_PHANTOM_T1_CHUANVO @id_agency nchar(10)
AS
BEGIN TRAN

	SELECT M.id_agency, D.id_dish, M.unit, D.dish_name, D.type_dish, D.image, D.price
	FROM MENU M JOIN DISH D with (RepeatableRead)
	ON id_agency = @id_agency AND M.id_dish = D.id_dish AND M.isActive =1

	WAITFOR DELAY '00:00:15'
COMMIT TRAN

--TRANSACTION 2
IF OBJECT_ID('PROC_PHANTOM_T2_CHUANVO', N'P') IS NOT NULL DROP PROC PROC_PHANTOM_T2_CHUANVO
GO
CREATE PROC PROC_PHANTOM_T2_CHUANVO
	@id_agency nchar(10),
	@id_dish nchar(10),
	@unit int
AS
BEGIN TRAN
	INSERT [dbo].[MENU] ([id_agency], [id_dish], [unit], [isActive]) 
	VALUES (@id_agency, @id_dish, @unit, 1)	
COMMIT TRAN

--FIX => TRANSACTION 1--
IF OBJECT_ID('PROC_PHANTOM_T1_CHUANVO', 'P') IS NOT NULL DROP PROC PROC_PHANTOM_T1_CHUANVO
GO
CREATE PROC PROC_PHANTOM_T1_CHUANVO @id_agency nchar(10)
AS
BEGIN TRAN

	SELECT M.id_agency, D.id_dish, M.unit, D.dish_name, D.type_dish, D.image, D.price
	FROM MENU M JOIN DISH D with (Serializable)
	ON id_agency = @id_agency AND M.id_dish = D.id_dish AND M.isActive =1

	--WAITFOR DELAY '00:00:15'

COMMIT TRAN



--T1
EXEC PROC_PHANTOM_T1_CHUANVO 'ag_1'

--T2(ERROR)
EXEC PROC_PHANTOM_T2_CHUANVO 'dish_5', 10, 'ag_1'

--T1(FIXED)
EXEC PROC_PHANTOM_T1_CHUANVO 'ag_1'