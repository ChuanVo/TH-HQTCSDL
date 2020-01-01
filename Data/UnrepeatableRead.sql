USE HuongVietRestaurant
GO

--============> UNREPEATABLE READ <==========

--ChuanVo
-- Khách hàng đang xem thông tin món ăn thì người quản lý cập nhật giá của món ăn.
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

--Lam
-- Khách hàng đang xem thông tin món ăn thì người quản lý cập nhật hình ảnh của món ăn.
--TRANSACTION 1--
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T1_LAM', 'P') IS NOT NULL DROP PROC PROC_UNREPEATABLEREAD_T1_LAM
GO
CREATE PROC PROC_UNREPEATABLEREAD_T1_LAM @id_agency nchar(10)
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
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T2_LAM', 'P') IS NOT NULL DROP PROC PROC_UNREPEATABLEREAD_T2_LAM
GO
CREATE PROC PROC_UNREPEATABLEREAD_T2_LAM @id_dish nchar(10), @image nvarchar(50)
AS
BEGIN TRAN
	UPDATE DISH 
	SET [image] = @image
	WHERE id_dish = @id_dish and isActive = 1 
COMMIT TRAN

--FIX =>TRANSACTION 1--
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T1_LAM', N'P') IS NOT NULL DROP PROC PROC_UNREPEATABLEREAD_T1_LAM
GO
CREATE PROC PROC_UNREPEATABLEREAD_T1_LAM @id_agency nchar(10)
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


--TrungDuc
--Khách A xem danh sách các món ăn tại chi nhánh 1 có  SL >=1,
-- khách B mua hết 1 món trong đó ( update SL = 0)
--TRANSACTION 1--
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T1_TRUNGDUC', N'P') IS NOT NULL DROP PROC PROC_UNREPEATABLEREAD_T1_TRUNGDUC
GO
CREATE PROC PROC_UNREPEATABLEREAD_T1_TRUNGDUC
	@id_agency nchar(10)
AS
BEGIN TRAN

	SELECT M.id_agency, D.id_dish, M.unit, D.dish_name, D.type_dish, D.image, D.price
	FROM MENU M JOIN DISH D 
	ON id_agency = @id_agency AND M.id_dish = D.id_dish AND M.isActive = 1 AND M.unit >= 1

	WAITFOR DELAY '00:00:15'

	SELECT M.id_agency, D.id_dish, M.unit, D.dish_name, D.type_dish, D.image, D.price
	FROM MENU M JOIN DISH D 
	ON id_agency = @id_agency AND M.id_dish = D.id_dish AND M.isActive = 1 AND M.unit >= 1
	
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
SET TRAN ISOLATION LEVEL REPEATABLE READ

	SELECT M.id_agency, D.id_dish, M.unit, D.dish_name, D.type_dish, D.image, D.price
	FROM MENU M JOIN DISH D 
	ON id_agency = @id_agency AND M.id_dish = D.id_dish AND M.isActive = 1 AND M.unit >= 1

	WAITFOR DELAY '00:00:15'

	SELECT M.id_agency, D.id_dish, M.unit, D.dish_name, D.type_dish, D.image, D.price
	FROM MENU M JOIN DISH D 
	ON id_agency = @id_agency AND M.id_dish = D.id_dish AND M.isActive = 1 AND M.unit >=1
	
COMMIT TRAN
GO

EXEC PROC_UNREPEATABLEREAD_T1_TRUNGDUC N'ag_1'

--AnHoa
--Mô tả: Khách hàng tìm kiếm danh sách món dưới 50.000. Trong lúc đó quản lý cập nhật giá 1 món ăn giá từ dưới 50.000 thành trên 50.000 -> dẫn đến món ăn nằm ngoài danh sách khách hàng tìm kiếm.
--TRANSACTION 1:
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T1_ANHOA', 'p') is not null DROP PROC PROC_UNREPEATABLEREAD_T1_ANHOA
GO
CREATE PROC PROC_UNREPEATABLEREAD_T1_ANHOA @id_agency nchar(10), @price int
AS
BEGIN TRAN
	SELECT M.id_agency, D.id_dish, M.unit, D.dish_name, D.type_dish, D.image, D.price
	FROM MENU M JOIN DISH D 
	ON id_agency = @id_agency AND M.id_dish = D.id_dish AND M.isActive = 1 AND D.price < @price

	WAITFOR DELAY '00:00:15'

	SELECT M.id_agency, D.id_dish, M.unit, D.dish_name, D.type_dish, D.image, D.price
	FROM MENU M JOIN DISH D 
	ON id_agency = @id_agency AND M.id_dish = D.id_dish AND M.isActive = 1 AND D.price < @price
COMMIT TRAN  
EXEC PROC_UNREPEATABLEREAD_T1_ANHOA 'ag_1', 50000

--TRANSACTION 2:
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T2_ANHOA', 'p') is not null DROP PROC PROC_UNREPEATABLEREAD_T2_ANHOA
GO
CREATE PROC PROC_UNREPEATABLEREAD_T2_ANHOA @id_dish nchar(10), @price int
AS
BEGIN TRAN
	UPDATE DISH
	SET price = @price
	WHERE id_dish = @id_dish
COMMIT TRAN
EXEC PROC_UNREPEATABLEREAD_T2_ANHOA 'dish_5', 70000

--TRANSACTION 1 FIX:
IF OBJECT_ID('PROC_UNREPEATABLEREAD_T1_ANHOA', 'p') is not null DROP PROC PROC_UNREPEATABLEREAD_T1_ANHOA
GO
CREATE PROC PROC_UNREPEATABLEREAD_T1_ANHOA @id_agency nchar(10), @price int
AS
BEGIN TRAN
SET TRAN ISOLATION LEVEL REPEATABLE READ
	SELECT M.id_agency, D.id_dish, M.unit, D.dish_name, D.type_dish, D.image, D.price
	FROM MENU M JOIN DISH D 
	ON id_agency = @id_agency AND M.id_dish = D.id_dish AND M.isActive = 1 AND D.price < @price

	--WAITFOR DELAY '00:00:15'

	SELECT M.id_agency, D.id_dish, M.unit, D.dish_name, D.type_dish, D.image, D.price
	FROM MENU M JOIN DISH D 
	ON id_agency = @id_agency AND M.id_dish = D.id_dish AND M.isActive = 1 AND D.price < @price
COMMIT TRAN     
EXEC PROC_UNREPEATABLEREAD_T1_ANHOA 'ag_1', 50000
