USE HuongVietRestaurant
GO

--===============> TEST CASE DIRTY READ <==============

--ChuanVo
EXEC sp_DirtyReadChuanVo 'dish_1', '35000'

EXEC sp_TestCaseDirtyReadChuanVo_F 'dish_1'

EXEC sp_TestCaseDirtyReadChuanVo_T 'dish_1'
