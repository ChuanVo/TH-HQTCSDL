USE HuongVietRestaurant
GO

--============> DEADLOCK <==========

--ChuanVo

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
	set tran isolation level repeatable read
	SELECT * 
	FROM MENU m
	WHERE m.id_dish = @id_dish and m.id_agency = @id_agency and m.isActive = 1
	WAITFOR DELAY '00:00:15'

	UPDATE MENU
	SET unit = @unit
	WHERE id_dish = @id_dish and id_agency = @id_agency and isActive = 1
	
COMMIT TRAN
GO

EXEC PROC_DEADLOCK_T1_LANG N'dish_5', N'ag_1', 50

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
	FROM MENU m
	WHERE m.id_dish = @id_dish and m.id_agency = @id_agency and m.isActive = 1 

	UPDATE MENU
	SET unit = @unit
	WHERE id_dish = @id_dish and id_agency = @id_agency and isActive = 1
	
COMMIT TRAN
GO

EXEC PROC_DEADLOCK_T2_LANG N'dish_5', N'ag_1', 100 

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
	FROM MENU m with (updlock)
	WHERE m.id_dish = @id_dish and m.id_agency = @id_agency and m.isActive = 1 

	UPDATE MENU
	SET unit = @unit
	WHERE id_dish = @id_dish and id_agency = @id_agency and isActive = 1
	
COMMIT TRAN
GO

EXEC PROC_DEADLOCK_T2_LANG N'dish_5', N'ag_1', 100 

--TrungDuc

--DangLam

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
