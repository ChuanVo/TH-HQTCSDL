USE HuongVietRestaurant
GO
--===============> TEST CASE 12 <==============

/*
- TestCase12: 
- Tình huống:Người quản lý A xem toàn bộ đơn hàng (chưa xong) thì có đơn hàng mới được tạo.
- Hướng dẫn sử dụng: 
	+ Bước 1: Chạy TRANSACTION T1 
	+ Bước 2: Trong vòng 15 giây kể từ khi chạy TRANSACTION T1 ta chạy TRANSACTION T2
*/
--T1: quản lý A xem toàn bộ đơn hàng
IF OBJECT_ID('PROC_PHANTOM_T1_TRUNGDUC', 'p') is not null DROP PROC PROC_PHANTOM_T1_TRUNGDUC
GO
CREATE PROC PROC_PHANTOM_T1_TRUNGDUC
	@id_agency nchar(10)
AS
BEGIN TRAN
	SELECT COUNT(*) 
	FROM BILL b
	WHERE b.agency = @id_agency and b.isActive = 1
	WAITFOR DELAY '00:00:10'
COMMIT TRAN 



--T2: Đơn hàng mới được tạo
IF OBJECT_ID('PROC_PHANTOM_T2_TRUNGDUC', 'p') is not null DROP PROC PROC_PHANTOM_T2_TRUNGDUC
GO
CREATE PROC PROC_PHANTOM_T2_TRUNGDUC
	@id_bill nchar(10),
	@agency nchar(10),
	@customer nchar(10),
	@status nchar(10),
	@order nchar(10),
	@payment_method nchar(10),
	@total float,
	@fee nchar(10),
	@isActive float
AS
BEGIN TRAN
	INSERT INTO BILL(id_bill,agency,customer,status,[order],payment_method,total,fee,isActive)
	VALUES (@id_bill,@agency,@customer,@status,@order,@payment_method,@total,@fee,@isActive)
COMMIT TRAN

EXEC PROC_PHANTOM_T2_TRUNGDUC 
N'bill_5    ', N'ag_2      ', N'cus_2     ', N'sta_2     ', N'order_2   ', N'pay_1     ', 69000, N'fee_1     ', 1

--T1 FIX: quản lý A xem toàn bộ đơn hàng
GO
IF OBJECT_ID('PROC_PHANTOM_T1_TRUNGDUC', 'p') is not null DROP PROC PROC_PHANTOM_T1_TRUNGDUC
GO
CREATE PROC PROC_PHANTOM_T1_TRUNGDUC
	@id_agency nchar(10)
AS
BEGIN TRAN
	SELECT COUNT(*) 
	FROM BILL b WITH (Serializable)
	WHERE b.agency = @id_agency and b.isActive = 1
	WAITFOR DELAY '00:00:10'
COMMIT TRAN 



--T1
EXEC PROC_PHANTOM_T1_TRUNGDUC 'ag_1'

--T2(ERROR)
EXEC PROC_PHANTOM_T2_TRUNGDUC 
N'bill_5    ', N'ag_2      ', N'cus_2     ', N'sta_2     ', N'order_2   ', N'pay_1     ', 69000, N'fee_1     ', 1


--T1(FIXED)
EXEC PROC_PHANTOM_T1_TRUNGDUC 'ag_1'