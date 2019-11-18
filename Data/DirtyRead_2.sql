USE HuongVietRestaurant
GO

--===============> DIRTY READ <==============

--ChuanVo
-- Create
BEGIN TRAN
SET TRAN ISOLATION LEVEL REPEATABLE READ 
	SELECT * 
	FROM DISH 
	WHERE id_dish = 'dish_1' 
COMMIT TRAN

-- Handle: Use insolation level READ COMMITED to handle this error and it is default insolation level of sql server
BEGIN TRAN
	SELECT * 
	FROM DISH 
	WHERE id_dish = 'dish_1' 
COMMIT TRAN
