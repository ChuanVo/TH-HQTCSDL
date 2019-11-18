USE HuongVietRestaurant
GO

--============> DIRTY READ <==========

--ChuanVo
BEGIN TRAN
SET TRAN ISOLATION LEVEL REPEATABLE READ 

	UPDATE DISH 
	SET price = 25000
	WHERE id_dish = 'dish_1' 
	
	WAITFOR DELAY '00:00:15'

	ROLLBACK TRAN
