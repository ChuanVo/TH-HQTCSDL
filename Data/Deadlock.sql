USE HuongVietRestaurant
GO

--============> DEADLOCK <==========

--ChuanVo 
--Giao tác T1:
--		+ UPDATE DISH set dish_name = 'món ăn 1' where id_dish = 'X'
--		+ wait(15'')
-- 		+ UPDATE TYPE_DISH set type_name = 'loại 1' where id_type = 'P'  
--Giao tác T2:
--		+ UPDATE DISH set dish_name = 'món ăn 1' where id_dish = 'X' 
--		+ wait(15'')
-- 		+ UPDATE TYPE_DISH set type_name = 'loại 1' where id_type = 'P'  
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

EXEC PROC_DEADLOCK_T1_CHUAN 'dish_1', N'Rong biet vuot dai duong', 'td_1', 'Ngon'


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

EXEC PROC_DEADLOCK_T2_CHUAN 'dish_1', N'Rong biet vuot dai duong', 'td_1', 'Ngon'

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

EXEC PROC_DEADLOCK_T2_CHUAN 'dish_1', N'Rong biet vuot dai duong', 'td_1', 'Ngon'


--Lam 
--Giao tác T1:
--		+ SELECT * from TYPE_DISH where id_type_dish = '01'
--		+ wait(5")
-- 		+ UPDATE TYPE_DISH set type_dish_name = 'loại món gì đó ?' where id_type_dish = '01'  
--Giao tác T2:
--		+ SELECT * from TYPE_DISH where id_type_dish = '01'
--		+ wait(15'')
-- 		+ UPDATE TYPE_DISH set dish_name = 'loại món mặn chằng' where id_type_dish = '01' 
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

EXEC PROC_DEADLOCK_T1_LAM 'td_1', N'Mon ngon'


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

EXEC PROC_DEADLOCK_T2_LAM 'td_1', N'Mon ngon'

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

EXEC PROC_DEADLOCK_T2_LAM 'dish_1', N'Rong biet vuot dai duong', 'td_1', 'Ngon'



--Lang

--ADMIN A đang xem  thông tin món bún bò tại chi nhánh 1 -> cập nhật số lượng món bún bò tại chi nhánh 1(chưa commit) delay 5s
--ADMIN B cũng xem  thông tin món bún bò tại chi nhánh 1 -> cập nhật số lượng món bún bò tại chi nhánh 1(commit)

--TRANSACTION 1 --
IF OBJECT_ID('PROC_DEADLOCK_T1_LANG', N'P') IS NOT NULL DROP PROC PROC_DEADLOCK_T1_LANG
GO
CREATE PROC PROC_DEADLOCK_T1_LANG
	@id_dish nchar(10),
	@id_agency nchar(10),
	@unit int
AS
BEGIN TRAN
	SELECT * 
	FROM MENU m WITH(HOLDLOCK)
	WHERE m.id_dish = @id_dish and m.id_agency = @id_agency and m.isActive = 1
	WAITFOR DELAY '00:00:10'

	UPDATE MENU WITH(XLOCK)
	SET unit = @unit
	WHERE id_dish = @id_dish and id_agency = @id_agency and isActive = 1
	
COMMIT TRAN

EXEC PROC_DEADLOCK_T1_LANG 'dish_1', 'ag_1', 11


--TRANSACTION 2 --
IF OBJECT_ID('PROC_DEADLOCK_T2_LANG', N'P') IS NOT NULL DROP PROC PROC_DEADLOCK_T2_LANG
GO
CREATE PROC PROC_DEADLOCK_T2_LANG
	@id_dish nchar(10),
	@id_agency nchar(10),
	@unit int
AS
BEGIN TRAN
	
	SELECT *
	FROM MENU m WITH(HOLDLOCK)
	WHERE m.id_dish = @id_dish and m.id_agency = @id_agency and m.isActive = 1 
	WAITFOR DELAY '00:00:10'

	UPDATE MENU WITH (XLOCK)
	SET unit = @unit
	WHERE id_dish = @id_dish and id_agency = @id_agency and isActive = 1
	
COMMIT TRAN
GO

EXEC PROC_DEADLOCK_T2_LANG 'dish_1', 'ag_1', 232
--TRANSACTION 2 FIX--
IF OBJECT_ID('PROC_DEADLOCK_T2_LANG', N'P') IS NOT NULL DROP PROC PROC_DEADLOCK_T2_LANG
GO
CREATE PROC PROC_DEADLOCK_T2_LANG
	@id_dish nchar(10),
	@id_agency nchar(10),
	@unit int
AS
BEGIN TRAN
	
	SELECT *
	FROM MENU m WITH (NOLOCK) 
	WHERE m.id_dish = @id_dish and m.id_agency = @id_agency and m.isActive = 1 
	WAITFOR DELAY '00:00:10'

	UPDATE MENU WITH (XLOCK)
	SET unit = @unit
	WHERE id_dish = @id_dish and id_agency = @id_agency and isActive = 1
	
COMMIT TRAN

EXEC PROC_DEADLOCK_T2_LANG 'dish_1', 'ag_1', 232


--AnHoa

--Mô tả: 
	--Giao tác T1: 
	--Quản lý 1 xem danh sách các món hiện có (khi này sẽ giữ khóa đọc)
	--Delay 15s (Giao tác B thực hiện)
	--Quản lý 1 muốn thêm một món vào danh sách nhưng không thực hiện được (chờ giao tác B nhả khóa).
	--Giao tác T2:
	--Quản lý 2 xem danh sách các món hiện có (giữ khóa đọc)
	--Quản lý 2 xóa 1 món trong danh sách nhưng không thực hiện được vì ở giao tác A chưa nhả khóa (chờ giao tác A). Và giao tác B cũng không nhả khóa.
	-- => Dẫn đến 2 tác chờ nhau và deadlock xảy ra

--TRANSACTION 1:
IF OBJECT_ID('PROC_DEADLOCK_T1_ANHOA', 'p') is not null DROP PROC PROC_DEADLOCK_T1_ANHOA
GO
CREATE PROC PROC_DEADLOCK_T1_ANHOA @id_dish nchar(10), @id_typedish nchar(10), @dishname nvarchar(50), @price int, @image nvarchar(50)
AS
BEGIN TRAN
	SELECT *
	FROM DISH WITH (HOLDLOCK)  --Phát khóa đọc trên bảng DISH
	WAITFOR DELAY '00:00:15'
	INSERT INTO DISH WITH (XLOCK)(id_dish, type_dish, dish_name, price, image, isActive)  --Phát khóa ghi (nhưng không được vì khóa đọc chưa mở)
	VALUES (@id_dish, @id_typedish, @dishname, @price, @image, 1)
COMMIT TRAN
EXEC PROC_DEADLOCK_T1_ANHOA 'dish_21', 'td_1', 'Bánh tráng', 10000, './'

--TRANSACTION 2:
IF OBJECT_ID('PROC_DEADLOCK_T2_ANHOA', 'p') is not null DROP PROC PROC_DEADLOCK_T2_ANHOA
GO
CREATE PROC PROC_DEADLOCK_T2_ANHOA @id_dish nchar(10)
AS
BEGIN TRAN
	SELECT *
	FROM DISH WITH (HOLDLOCK)  --Phát khóa đọc trên bảng DISH
	WAITFOR DELAY '00:00:15'
	UPDATE DISH WITH (XLOCK) 
	SET isActive = 0
	WHERE id_dish = @id_dish
COMMIT TRAN
EXEC PROC_DEADLOCK_T2_ANHOA 'dish_1'

--TRANSACTION 2 FIX:
IF OBJECT_ID('PROC_DEADLOCK_T2_ANHOA', 'p') is not null DROP PROC PROC_DEADLOCK_T2_ANHOA
GO
CREATE PROC PROC_DEADLOCK_T2_ANHOA @id_dish nchar(10)
AS
BEGIN TRAN
	SELECT *
	FROM DISH WITH (NOLOCK) 
	WAITFOR DELAY '00:00:15'
	UPDATE DISH
	SET isActive = 0
	WHERE id_dish = @id_dish
COMMIT TRAN
EXEC PROC_DEADLOCK_T2_ANHOA 'dish_1'


--TrungDuc
/*Giao tác A: 
- Quản lý 1 xem tình trạng đơn hàng của id_bill  'X' (khi này sẽ giữ khóa đọc)
- Delay 10s (Giao tác B thực hiện)
- Quản lý 1 muốn cập nhật tình trạng đơn hàng cho  id_bill  'X' nhưng không thực hiện được (chờ giao tác B nhả khóa).
Giao tác B:
- Quản lý 2 xem tình trạng đơn hàng của id_bill  'X' (khi này sẽ giữ khóa đọc)
- Delay 10s (Giao tác B thực hiện)
- Quản lý 2 muốn cập nhật tình trạng đơn hàng cho  id_bill  'X' nhưng không thực hiện được (chờ giao tác B nhả khóa). Và giao tác B cũng không nhả khóa.
=> Dẫn đến 2 tác chờ nhau và deadlock xảy ra => DMBS sẽ kill 1 giáo tác */

--TRANSACTION 1 -- Quản lý 1 cập nhật tình trạng đơn hàng cho  id_bill  'X' tại chi nhánh 'Y'
IF OBJECT_ID('PROC_DEADLOCK_T1_TRUNGDUC', N'P') IS NOT NULL DROP PROC PROC_DEADLOCK_T1_TRUNGDUC
GO
CREATE PROC PROC_DEADLOCK_T1_TRUNGDUC
	@id_bill nchar(10),
	@id_agency nchar(10),
	@status nchar(10)
AS
BEGIN TRAN
	SELECT * 
	FROM BILL b WITH(HOLDLOCK)
	WHERE b.id_bill = @id_bill and b.agency = @id_agency and b.isActive = 1
	WAITFOR DELAY '00:00:10'

	UPDATE BILL WITH(XLOCK)
	SET status = @status
	WHERE id_bill = @id_bill and agency = @id_agency and isActive = 1
COMMIT TRAN
GO

EXEC PROC_DEADLOCK_T1_TRUNGDUC N'bill_1', N'ag_1', N'sta_4'

--TRANSACTION 2 --Quản lý 2 cập nhật tình trạng đơn hàng cho  id_bill  'X' tại chi nhánh 'Y'
IF OBJECT_ID('PROC_DEADLOCK_T2_TRUNGDUC', N'P') IS NOT NULL DROP PROC PROC_DEADLOCK_T2_TRUNGDUC
GO
CREATE PROC PROC_DEADLOCK_T2_TRUNGDUC
	@id_bill nchar(10),
	@id_agency nchar(10),
	@status nchar(10)
AS
BEGIN TRAN
	SELECT * 
	FROM BILL b WITH(HOLDLOCK)
	WHERE b.id_bill = @id_bill and b.agency = @id_agency and b.isActive = 1
	WAITFOR DELAY '00:00:10'

	UPDATE BILL WITH(XLOCK)
	SET status = @status
	WHERE id_bill = @id_bill and agency = @id_agency and isActive = 1
COMMIT TRAN
GO

EXEC PROC_DEADLOCK_T2_TRUNGDUC N'bill_1', N'ag_1', N'sta_3'

--TRANSACTION 2 FIX --Quản lý 2 cập nhật tình trạng đơn hàng cho  id_bill  'X' tại chi nhánh 'Y'
IF OBJECT_ID('PROC_DEADLOCK_T2_TRUNGDUC', N'P') IS NOT NULL DROP PROC PROC_DEADLOCK_T2_TRUNGDUC
GO
CREATE PROC PROC_DEADLOCK_T2_TRUNGDUC
	@id_bill nchar(10),
	@id_agency nchar(10),
	@status nchar(10)
AS
BEGIN TRAN
	SELECT * 
	FROM BILL b WITH(NOLOCK)
	WHERE b.id_bill = @id_bill and b.agency = @id_agency and b.isActive = 1
	WAITFOR DELAY '00:00:10'

	UPDATE BILL WITH(XLOCK)
	SET status = @status
	WHERE id_bill = @id_bill and agency = @id_agency and isActive = 1

COMMIT TRAN
GO

EXEC PROC_DEADLOCK_T2_TRUNGDUC N'bill_1', N'ag_1', N'sta_3'