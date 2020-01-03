USE HuongVietRestaurant
GO
--===============> TEST CASE 14 <==============

/*
- TestCase14: 
- Tình huống: Trong khi người quản lý xem danh sách nhân viên (chưa xong) thì người quản lý khác thêm nhân viên mới vào nhà hàng.
- Hướng dẫn sử dụng: 
	+ Bước 1: Chạy TRANSACTION T1 
	+ Bước 2: Trong vòng 15 giây kể từ khi chạy TRANSACTION T1 ta chạy TRANSACTION T2
*/
--TRANSACTION 1--
IF OBJECT_ID('PROC_PHANTOM_T1_LAM', 'P') IS NOT NULL DROP PROC PROC_PHANTOM_T1_LAM
GO
CREATE PROC PROC_PHANTOM_T1_LAM
AS
BEGIN TRAN
	SELECT * 
	FROM EMPLOYEE
	WHERE isActive = 1
	WAITFOR DELAY '00:00:15'
COMMIT TRAN

EXEC PROC_PHANTOM_T1_LAM

--TRANSACTION 2
IF OBJECT_ID('PROC_PHANTOM_T2_LAM', N'P') IS NOT NULL DROP PROC PROC_PHANTOM_T2_LAM
GO
CREATE PROC PROC_PHANTOM_T2_LAM
	@id_employee nchar(10),
	@name nvarchar(10),
	@gmail nvarchar(50),
	@id_card nvarchar(50),
	@address nchar(10),
	@position nchar(10),
	@agency nchar(10),
	@isActive int
AS
BEGIN TRAN
	INSERT [dbo].[EMPLOYEE] ([id_employee], [name], [gmail], [id_card], [address], [position], [agency], [isActive]) 
	VALUES (@id_employee, @name, @gmail, @id_card, @address, @position, @agency, @isActive)	
COMMIT TRAN

--FIX => TRANSACTION 1--
IF OBJECT_ID('PROC_PHANTOM_T1_LAM', 'P') IS NOT NULL DROP PROC PROC_PHANTOM_T1_LAM
GO
CREATE PROC PROC_PHANTOM_T1_LAM
AS
BEGIN TRAN
	SELECT * 
	FROM EMPLOYEE with (Serializable) 
	WHERE isActive = 1
	WAITFOR DELAY '00:00:15'
COMMIT TRAN

--T1
EXEC PROC_PHANTOM_T1_ANHOA 'ag_1'

--T2(ERROR)
EXEC PROC_PHANTOM_T2_ANHOA 'ag_2', 'dish_3', 20

--T1(FIXED)
EXEC PROC_PHANTOM_T1_ANHOA 'ag_1'