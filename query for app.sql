USE HuongVietRestaurant
go

select * from BILL
select * from BILL_DETAIL

SELECT MAX(CAST(STUFF(id_bill, 1, 5, '') AS INT)) + 1 FROM BILL

if OBJECT_ID('USP_Insert_Bill', 'p') is not null drop proc USP_Insert_Bill
go
create proc USP_Insert_Bill @id_bill nchar(10), @id_agency nchar(10)
as
begin
	insert into [dbo].[BILL]
           ([id_bill]
           ,[agency]
           ,[customer]
           ,[status]
           ,[order]
           ,[payment_method]
           ,[total]
           ,[fee]
           ,[isActive])
     values
           (@id_bill
           ,@id_agency
           ,null
           ,null
           ,null
           ,null
           ,0
           ,null
           ,1)
end
go


IF OBJECT_ID('USP_Insert_Bill_Detail', 'p') IS NOT NULL DROP PROC USP_Insert_Bill_Detail
GO
CREATE PROC USP_Insert_Bill_Detail @id_bill NCHAR(10), @id_food NCHAR(10), @unit INT
AS
BEGIN
	DECLARE @isExitsBillInfo INT
	DECLARE @foodCount INT = 1

	SELECT @isExitsBillInfo = count(id_bill)
	FROM BILL_DETAIL AS b 
	WHERE id_bill = @id_bill AND dish = @id_food


	IF (@isExitsBillInfo > 0)
	BEGIN
		SELECT @foodCount = b.unit
		FROM BILL_DETAIL AS b 
		WHERE id_bill = @id_bill AND dish = @id_food

		DECLARE @newCount INT = @foodCount + @unit
		IF (@newCount > 0)
			UPDATE BILL_DETAIL	SET unit = @foodCount + @unit WHERE dish = @id_food
		ELSE
			DELETE BILL_DETAIL WHERE id_bill = @id_bill AND dish = @id_food
	END
	ELSE
	BEGIN
		IF (@unit > 0)
		BEGIN
			INSERT INTO [dbo].[BILL_DETAIL]
				   ([id_bill]
				   ,[dish]
				   ,[unit]
				   ,[receiver]
				   ,[isActive])
			 VALUES
				   (@id_bill
				   ,@id_food
				   ,@unit
				   ,null
				   ,1)
		END
	END
END
GO

