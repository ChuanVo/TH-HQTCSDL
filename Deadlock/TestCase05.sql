USE [HuongVietRestaurant]
GO

--Lỗi Deadlock
--Mô tả: 
	--Giao tác T1: 
	--Quản lý 1 xem danh sách các món hiện có (khi này sẽ giữ khóa đọc)
	--Delay 15s (Giao tác B thực hiện)
	--Quản lý 1 muốn thêm một món vào danh sách nhưng không thực hiện được (chờ giao tác B nhả khóa).
	--Giao tác T2:
	--Quản lý 2 xem danh sách các món hiện có (giữ khóa đọc)
	--Quản lý 2 xóa 1 món trong danh sách nhưng không thực hiện được vì ở giao tác A chưa nhả khóa (chờ giao tác A). Và giao tác B cũng không nhả khóa.
	-- => Dẫn đến 2 tác chờ nhau và deadlock xảy ra

--T1:
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

--T2:
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

--Các bước thực hiện.
--Bước 1: Chạy lệnh thực thi PROC T1, HOLDLOCK sẽ phát khóa đọc cho bảng DISH đến hết giao tác, lúc này trễ 15s ta chạy giao tác T2.
EXEC PROC_DEADLOCK_T1_ANHOA 'dish_21', 'td_1', 'Bánh tráng', 10000, './'
--Bước 2: Chạy lệnh thực thi PROC T2. 
EXEC PROC_DEADLOCK_T2_ANHOA 'dish_1'
/*HOLDLOCK tiếp tục phát khóa đọc cho bảng DISH (hợp lệ vì cùng là khóa đọc), lúc này trễ 15s là lúc mà giao tác T1 thực hiện thêm vào DISH và yêu cầu cấp khóa ghi
nhưng không được vì khóa đọc chưa được mở, tương tự vậy ở T2
=> 2 giao tác chờ nhau => dẫn đến deadlock => DBMS chọn giao tác T2 làm nạn nhân và T2 bị hủy => T1 thực hiện thành công.*/

--Cách giải quyết: ta sẽ phát khóa cho T1, T2 sẽ không được phát khóa khi đó T2 sẽ chờ T1 thực hiện xong rồi sẽ thực hiện
--T1: Giữ như trên.
--T2:
IF OBJECT_ID('PROC_FIX_DEADLOCK_ANHOA', 'p') is not null DROP PROC PROC_FIX_DEADLOCK_ANHOA
GO
CREATE PROC PROC_FIX_DEADLOCK_ANHOA @id_dish nchar(10)
AS
BEGIN TRAN
	SELECT *
	FROM DISH WITH (NOLOCK)  --Phát khóa đọc trên bảng DISH
	WAITFOR DELAY '00:00:15'
	UPDATE DISH
	SET isActive = 0
	WHERE id_dish = @id_dish
COMMIT TRAN