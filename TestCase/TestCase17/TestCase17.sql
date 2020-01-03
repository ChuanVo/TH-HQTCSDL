USE HuongVietRestaurant
GO
--===============> TEST CASE 17 <==============

/*
- TestCase17: 
- Tình huống: Khách hàng đang xem thông tin món ăn thì người quản lý cập nhật giá của món ăn
- Hướng dẫn sử dụng: 
	+ Bước 1: Chạy TRANSACTION T1 
	+ Bước 2: Trong vòng 15 giây kể từ khi chạy TRANSACTION T1 ta chạy TRANSACTION T2
*/
--TRANSACTION 1--
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T1_CHUAN', 'P') IS NOT NULL DROP PROC PROC_UNREPEATABLEREAD_T1_CHUAN
GO
CREATE PROC PROC_UNREPEATABLEREAD_T1_CHUAN @id_agency nchar(10)
AS
BEGIN TRAN
	SELECT M.id_agency, D.id_dish, M.unit, D.dish_name, D.type_dish, D.image, D.price
	FROM MENU M JOIN DISH D
	ON id_agency = @id_agency AND M.id_dish = D.id_dish AND M.isActive =1
	WAITFOR DELAY '00:00:15'


	SELECT M.id_agency, D.id_dish, M.unit, D.dish_name, D.type_dish, D.image, D.price
	FROM MENU M JOIN DISH D
	ON id_agency = @id_agency AND M.id_dish = D.id_dish AND M.isActive =1

COMMIT TRAN

--TRANSACTION 2--
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T2_CHUAN', 'P') IS NOT NULL DROP PROC PROC_UNREPEATABLEREAD_T2_CHUAN
GO
CREATE PROC PROC_UNREPEATABLEREAD_T2_CHUAN @id_dish nchar(10), @price int
AS
BEGIN TRAN
	UPDATE DISH 
	SET [price] = @price
	WHERE id_dish = @id_dish and isActive = 1 
COMMIT TRAN

--FIX =>TRANSACTION 1--
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T1_CHUAN', N'P') IS NOT NULL DROP PROC PROC_UNREPEATABLEREAD_T1_CHUAN
GO
CREATE PROC PROC_UNREPEATABLEREAD_T1_CHUAN @id_agency nchar(10)
AS
BEGIN TRAN
	SELECT M.id_agency, D.id_dish, M.unit, D.dish_name, D.type_dish, D.image, D.price
	FROM MENU M JOIN DISH D WITH (RepeatableRead)
	ON id_agency = @id_agency AND M.id_dish = D.id_dish AND M.isActive =1
	WAITFOR DELAY '00:00:15'


	SELECT M.id_agency, D.id_dish, M.unit, D.dish_name, D.type_dish, D.image, D.price
	FROM MENU M JOIN DISH D
	ON id_agency = @id_agency AND M.id_dish = D.id_dish AND M.isActive =1

COMMIT TRAN


--T1
EXEC PROC_UNREPEATABLEREAD_T1_CHUAN N'ag_1'

--T2
EXEC PROC_UNREPEATABLEREAD_T2_CHUAN N'dish_1', 26000

--T1(FIXED)
EXEC PROC_UNREPEATABLEREAD_T1_CHUAN N'ag_1'