USE [HuongVietRestaurant]
GO

--Lỗi Lost Update
--Mô tả: Khách hàng A đang xem thông tin món X, thì khách hàng B cũng xem thông tin món X rồi đặt mua làm số lượng món giảm, khách hàng A đặt mua món X làm số lượng món giảm.

--T1: Khách hàng A mua món @id_dish tại chi nhánh @id_agency với số lượng @unit
IF OBJECT_ID('PROC_LOSTUPDATE_T1_ANHOA', 'p') is not null DROP PROC PROC_LOSTUPDATE_T1_ANHOA
GO
CREATE PROC PROC_LOSTUPDATE_T1_ANHOA @id_agency nchar(10), @id_dish nchar(10), @unit int
AS
BEGIN TRAN
	BEGIN
	SELECT D.dish_name, A.agency_name, T.type_dish_name, D.price, M.unit
	FROM AGENCY A, MENU M, DISH D, TYPE_DISH T
	WHERE A.id_agency = @id_agency AND A.id_agency = M.id_agency AND M.id_dish = D.id_dish AND D.type_dish = T.id_type_dish AND D.id_dish = @id_dish
	END
	WAITFOR DELAY '00:00:15'
	BEGIN
	UPDATE MENU
	SET unit = unit - @unit
	WHERE id_agency = @id_agency AND id_dish = @id_dish
	END
COMMIT TRAN

--T2: Khách hàng B mua món @id_dish trùng với T1 tại chi nhánh @id_agency trùng với T1 với số lượng @unit
IF OBJECT_ID('PROC_LOSTUPDATE_T2_ANHOA', 'p') is not null DROP PROC PROC_LOSTUPDATE_T2_ANHOA
GO
CREATE PROC PROC_LOSTUPDATE_T2_ANHOA @id_agency nchar(10), @id_dish nchar(10), @unit int
AS
BEGIN TRAN
	BEGIN
	SELECT D.dish_name, A.agency_name, T.type_dish_name, D.price, M.unit
	FROM AGENCY A, MENU M, DISH D, TYPE_DISH T
	WHERE A.id_agency = @id_agency AND A.id_agency = M.id_agency AND M.id_dish = D.id_dish AND D.type_dish = T.id_type_dish AND D.id_dish = @id_dish
	END
	WAITFOR DELAY '00:00:15'
	BEGIN
	UPDATE MENU
	SET unit = unit - @unit
	WHERE id_agency = @id_agency AND id_dish = @id_dish
	END
COMMIT TRAN

--Các bước thực hiện.
--Bước 1: Chạy lệnh gọi Proc T1, thực thiện mua món dish_1 tại chi nhánh ag_1 với số lượng 1. Tuy nhiên trong 15 giây trễ chưa thực hiện việc trừ số lượng món trong db thì ta thực hiện bước 2.
EXEC PROC_LOSTUPDATE_T1_ANHOA 'ag_1', 'dish_1', 1
--Bước 2: Chạy lệnh gọi Proc T2, thực hiện mua món giống như T1 với số lượng 2. Trong thời gian trễ 15 giây thì T1 đã thực hiện trừ số lượng món đi, sau đó T2 mới thực hiện trừ số lượng món => Gây ra lỗi LostUpdate
EXEC PROC_LOSTUPDATE_T2_ANHOA 'ag_1', 'dish_1', 2

--Giải quyết lỗi: Cho T1 thực hiện xong cập nhật kết thúc giao tác thì T2 mới thực hiện. Ta cần sử dụng mức cô lập repeatableread cho T1 và T2 là uncommittedread.
--T1:
IF OBJECT_ID('PROC_FIX_LOSTUPDATE_T1_ANHOA', 'p') is not null DROP PROC PROC_FIX_LOSTUPDATE_T1_ANHOA
GO
CREATE PROC PROC_FIX_LOSTUPDATE_T1_ANHOA @id_agency nchar(10), @id_dish nchar(10), @unit int
AS
BEGIN TRAN
SET TRAN ISOLATION LEVEL REPEATABLE READ
	BEGIN
	SELECT D.dish_name, A.agency_name, T.type_dish_name, D.price, M.unit
	FROM AGENCY A, MENU M, DISH D, TYPE_DISH T
	WHERE A.id_agency = @id_agency AND A.id_agency = M.id_agency AND M.id_dish = D.id_dish AND D.type_dish = T.id_type_dish AND D.id_dish = @id_dish
	END
	WAITFOR DELAY '00:00:15'
	BEGIN
	UPDATE MENU
	SET unit = unit - @unit
	WHERE id_agency = @id_agency AND id_dish = @id_dish
	END
COMMIT TRAN
--T2:
IF OBJECT_ID('PROC_FIX_LOSTUPDATE_T2_ANHOA', 'p') is not null DROP PROC PROC_FIX_LOSTUPDATE_T2_ANHOA
GO
CREATE PROC PROC_FIX_LOSTUPDATE_T2_ANHOA @id_agency nchar(10), @id_dish nchar(10), @unit int
AS
BEGIN TRAN
SET TRAN ISOLATION LEVEL READ UNCOMMITTED 
	BEGIN
	SELECT D.dish_name, A.agency_name, T.type_dish_name, D.price, M.unit
	FROM AGENCY A, MENU M, DISH D, TYPE_DISH T
	WHERE A.id_agency = @id_agency AND A.id_agency = M.id_agency AND M.id_dish = D.id_dish AND D.type_dish = T.id_type_dish AND D.id_dish = @id_dish
	END
	WAITFOR DELAY '00:00:15'
	BEGIN
	UPDATE MENU
	SET unit = unit - @unit
	WHERE id_agency = @id_agency AND id_dish = @id_dish
	END
COMMIT TRAN