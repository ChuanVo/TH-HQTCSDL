USE HuongVietRestaurant
GO

--============> LOST UPDATE <==========


--ChuanVo
--Quản lý A cập nhật giá của món ăn, và quản lý B cũng cập nhật giá của món ăn.
--TRANSACTION 1
IF OBJECT_ID('PROC_LOSTUPDATE_T1_CHUANVO', N'P') IS NOT NULL DROP PROC PROC_LOSTUPDATE_T1_CHUANVO
GO
CREATE PROC PROC_LOSTUPDATE_T1_CHUANVO @id_dish nchar(10), @price int
AS
BEGIN
	BEGIN TRAN
		UPDATE DISH
		SET price = @price
		WHERE id_dish = @id_dish
		WAITFOR DELAY '00:00:15'
	COMMIT TRAN
END

--FIX => TRANSACTION 1
IF OBJECT_ID('PROC_LOSTUPDATE_T1_CHUANVO', N'P') IS NOT NULL DROP PROC PROC_LOSTUPDATE_T1_CHUANVO
GO
CREATE PROC PROC_LOSTUPDATE_T1_CHUANVO @id_dish nchar(10), @price int
AS
BEGIN
	BEGIN TRAN
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
		UPDATE DISH
		SET price = @price
		WHERE id_dish = @id_dish
		WAITFOR DELAY '00:00:15'
	COMMIT TRAN
END

IF OBJECT_ID('PROC_LOSTUPDATE_T2_CHUANVO', N'P') IS NOT NULL DROP PROC PROC_LOSTUPDATE_T2_CHUANVO
GO
CREATE PROC PROC_LOSTUPDATE_T2_CHUANVO @id_dish nchar(10), @price int
AS
BEGIN
	BEGIN TRAN
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
		UPDATE DISH
		SET price = @price
		WHERE id_dish = @id_dish
		WAITFOR DELAY '00:00:1'
	COMMIT TRAN
END



--Lang
--Admin nhà hàng đang cập nhật số lượng món Phở bò tại chi nhánh 1 giảm đi @unit (số lượng) (chưa commit), 
 --trong khi đó Admin A tại chi nhánh 1 bấm  "Thanh toán" 1 hóa đơn có món Phở bò (update số lượng món phở tại chi nhánh 1). 
 --TRANSACTION 1--
IF OBJECT_ID('PROC_LOSTUPDATE_T1_LANG', N'P') IS NOT NULL DROP PROC PROC_LOSTUPDATE_T1_LANG
GO
CREATE PROC PROC_LOSTUPDATE_T1_LANG
	@id_dish nchar(10),
	@unit int,
	@id_agency nchar(10)
AS
BEGIN TRAN
	DECLARE @unitnew int

	SELECT @unitnew = unit
	FROM MENU
	WHERE id_dish = @id_dish and id_agency = @id_agency and isActive = 1
	WAITFOR DELAY '00:00:10'
	SET @unitnew = @unitnew - @unit
	
	UPDATE MENU 
	SET unit = @unitnew
	WHERE id_dish = @id_dish and id_agency = @id_agency and isActive = 1
COMMIT TRAN
GO

EXEC PROC_LOSTUPDATE_T1_LANG 'dish_5', 2, 'ag_1'

 --TRANSACTION 2--
IF OBJECT_ID('PROC_LOSTUPDATE_T2_LANG', N'P') IS NOT NULL DROP PROC PROC_LOSTUPDATE_T2_LANG
GO
CREATE PROC PROC_LOSTUPDATE_T2_LANG
	@id_dish nchar(10),
	@unit int,
	@id_agency nchar(10)
AS
BEGIN TRAN
	DECLARE @unitnew int

	SELECT @unitnew = unit
	FROM MENU
	WHERE id_dish = @id_dish and id_agency = @id_agency and isActive = 1
	SET @unitnew = @unitnew - @unit
	
	UPDATE MENU 
	SET unit = @unitnew
	WHERE id_dish = @id_dish and id_agency = @id_agency and isActive = 1
COMMIT TRAN
GO

EXEC PROC_LOSTUPDATE_T2_LANG 'dish_5', 10, 'ag_1'

--TRANSACTION 2 FIX --
IF OBJECT_ID('PROC_LOSTUPDATE_T2_LANG', N'P') IS NOT NULL DROP PROC PROC_LOSTUPDATE_T2_LANG
GO
CREATE PROC PROC_LOSTUPDATE_T2_LANG
	@id_dish nchar(10),
	@unit int,
	@id_agency nchar(10)
AS
BEGIN TRAN
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
	DECLARE @unitnew int

	SELECT @unitnew = unit
	FROM MENU
	WHERE id_dish = @id_dish and id_agency = @id_agency and isActive = 1
	SET @unitnew = @unitnew - @unit
	
	UPDATE MENU 
	SET unit = @unitnew
	WHERE id_dish = @id_dish and id_agency = @id_agency and isActive = 1
COMMIT TRAN
GO
EXEC PROC_LOSTUPDATE_T2_LANG 'dish_5', 10, 'ag_1'

--TrungDuc

--Lam
--Quản lý A cập nhật tình trạng đơn hàng của đơn hàng D nhưng chưa commit thì người quản lý B cũng cập nhật tình 
-- tình trạng đơn hàng của  đơn hàng D. (2 quản lý cùng thuộc 1 chi nhánh)
--TRANSACTION 1
IF OBJECT_ID('PROC_LOSTUPDATE_T1_LAM', N'P') IS NOT NULL DROP PROC PROC_LOSTUPDATE_T1_LAM
GO
CREATE PROC PROC_LOSTUPDATE_T1_LAM @id_bill nchar(10), @status int
AS
BEGIN
	BEGIN TRAN
		UPDATE BILL 
		SET [status] = @status
		WHERE id_bill = @id_bill
		WAITFOR DELAY '00:00:15'
	COMMIT TRAN
END

--FIX => TRANSACTION 1
IF OBJECT_ID('PROC_LOSTUPDATE_T1_LAM', N'P') IS NOT NULL DROP PROC PROC_LOSTUPDATE_T1_LAM
GO
CREATE PROC PROC_LOSTUPDATE_T1_LAM @id_dish nchar(10), @price int
AS
BEGIN
	BEGIN TRAN
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
		UPDATE DISH
		SET price = @price
		WHERE id_dish = @id_dish
		WAITFOR DELAY '00:00:15'
	COMMIT TRAN
END


--EXECUTE
EXEC PROC_LOSTUPDATE_T1_LAM 'bill_1', 'sta_1'

--AnHoa

--Mô tả: Khách hàng A đang xem thông tin món X, thì khách hàng B cũng xem thông tin món X rồi đặt mua làm số lượng món giảm, khách hàng A đặt mua món X làm số lượng món giảm.

--TRANSACTION 1:
IF OBJECT_ID('PROC_LOSTUPDATE_T1_ANHOA', 'p') is not null DROP PROC PROC_LOSTUPDATE_T1_ANHOA
GO
CREATE PROC PROC_LOSTUPDATE_T1_ANHOA @id_agency nchar(10), @id_dish nchar(10), @unit int
AS
BEGIN TRAN
DECLARE @unit0 int
SET @unit0 = 0
	SELECT D.dish_name, A.agency_name, T.type_dish_name, D.price, M.unit
	FROM AGENCY A, MENU M, DISH D, TYPE_DISH T
	WHERE A.id_agency = @id_agency AND A.id_agency = M.id_agency AND M.id_dish = D.id_dish AND D.type_dish = T.id_type_dish AND D.id_dish = @id_dish	
	SELECT @unit0 = M.unit
	FROM MENU M
	WHERE M.id_agency = @id_agency AND M.id_dish = @id_dish

	WAITFOR DELAY '00:00:15'
	SET @unit0 = @unit0 - @unit
	UPDATE MENU
	SET unit = @unit0
	WHERE id_agency = @id_agency AND id_dish = @id_dish
COMMIT TRAN

EXEC PROC_LOSTUPDATE_T1_ANHOA 'ag_1', 'dish_1', 1

--TRANSACTION 2:
IF OBJECT_ID('PROC_LOSTUPDATE_T2_ANHOA', 'p') is not null DROP PROC PROC_LOSTUPDATE_T2_ANHOA
GO
CREATE PROC PROC_LOSTUPDATE_T2_ANHOA @id_agency nchar(10), @id_dish nchar(10), @unit int
AS
BEGIN TRAN
DECLARE @unit0 int
SET @unit0 = 0
	SELECT D.dish_name, A.agency_name, T.type_dish_name, D.price, M.unit
	FROM AGENCY A, MENU M, DISH D, TYPE_DISH T
	WHERE A.id_agency = @id_agency AND A.id_agency = M.id_agency AND M.id_dish = D.id_dish AND D.type_dish = T.id_type_dish AND D.id_dish = @id_dish	
	SELECT @unit0 = M.unit
	FROM MENU M
	WHERE M.id_agency = @id_agency AND M.id_dish = @id_dish

	SET @unit0 = @unit0 - @unit
	UPDATE MENU
	SET unit = @unit0
	WHERE id_agency = @id_agency AND id_dish = @id_dish	
COMMIT TRAN

EXEC PROC_LOSTUPDATE_T2_ANHOA 'ag_1', 'dish_1', 2

--FIX TRANSACTION T1:
IF OBJECT_ID('PROC_LOSTUPDATE_T1_ANHOA', 'p') is not null DROP PROC PROC_LOSTUPDATE_T1_ANHOA
GO
CREATE PROC PROC_LOSTUPDATE_T1_ANHOA @id_agency nchar(10), @id_dish nchar(10), @unit int
AS
BEGIN TRAN
SET TRAN ISOLATION LEVEL REPEATABLE READ
DECLARE @unit0 int
SET @unit0 = 0
	SELECT D.dish_name, A.agency_name, T.type_dish_name, D.price, M.unit
	FROM AGENCY A, MENU M, DISH D, TYPE_DISH T
	WHERE A.id_agency = @id_agency AND A.id_agency = M.id_agency AND M.id_dish = D.id_dish AND D.type_dish = T.id_type_dish AND D.id_dish = @id_dish	
	SELECT @unit0 = M.unit
	FROM MENU M
	WHERE M.id_agency = @id_agency AND M.id_dish = @id_dish

	WAITFOR DELAY '00:00:15'
	SET @unit0 = @unit0 - @unit
	UPDATE MENU
	SET unit = @unit0
	WHERE id_agency = @id_agency AND id_dish = @id_dish
COMMIT TRAN

EXEC PROC_LOSTUPDATE_T1_ANHOA 'ag_1', 'dish_1', 1
