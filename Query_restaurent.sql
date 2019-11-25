USE HuongVietRestaurant
GO
---------------------------
CREATE PROC usp_GetLishDish
AS
BEGIN
	SELECT D.id_dish, D.dish_name, D.price, T.type_dish_name, D.image, M.unit, A.agency_name
	FROM DISH D, TYPE_DISH T, MENU M, AGENCY A
	WHERE D.type_dish=T.id_type_dish and M.id_dish=D.id_dish and A.id_agency=M.id_agency
END

EXEC usp_GetLishDish


---------------------------
CREATE PROC usp_GetLishTypeDish
AS
BEGIN
	SELECT T.type_dish_name
	FROM TYPE_DISH T
END

EXEC usp_GetLishTypeDish

---------------------------
CREATE PROC usp_GetLishAgency
AS
BEGIN
	SELECT A.agency_name
	FROM AGENCY A
END

EXEC usp_GetLishAgency

---------------------------
CREATE PROC usp_AddDish
	@id_dish nchar(10),
	@type_dish_name nvarchar(50),
	@dish_name nvarchar(50),
	@price int,
	@image nvarchar(50),
	@unit int,
	@agency nvarchar(50)
AS
BEGIN
	--lay id cua type_dish
	DECLARE @id_type_dish nchar(10)
	SELECT @id_type_dish = T.id_type_dish
	FROM TYPE_DISH T
	WHERE T.type_dish_name = N'Món khô'
	--WHERE T.type_dish_name = @type_dish_name
	--them mon an
	INSERT INTO DISH (id_dish, type_dish, dish_name, price, image, isActive) VALUES (@id_dish, @id_type_dish, @dish_name, @price, @image, '1')
	--lay id cua nha hang
	--DECLARE @id_agency nchar(10)
	--SELECT @id_agency = A.id_agency
	--FROM AGENCY A
	--WHERE A.agency_name = N''+ @agency
	--lay id cua mon an vua them
	--DECLARE @id_dish nchar(10)
	--SELECT TOP 1 @id_dish = D.id_dish FROM DISH D ORDER BY D.id_dish DESC
	--them mon an vao menu
	INSERT INTO MENU (id_agency, id_dish, unit, isActive) VALUES ('ag_1', @id_dish, @unit, '1')
END



-------------------------------
CREATE PROC usp_UpdateDish
	@id_dish nchar(10),
	@type_dish_name nvarchar(50),
	@dish_name nvarchar(50),
	@price int,
	@image nvarchar(50),
	@unit int
AS
BEGIN
--Update Dish
	UPDATE DISH SET dish_name = @dish_name, price = @price, type_dish = 'td_1', image = @image WHERE id_dish = @id_dish
--Update Menu
	UPDATE MENU SET unit = @unit WHERE id_dish = @id_dish AND id_agency = 'ag_1'
END


------------------------------
CREATE PROC usp_DeleteDish @id_dish nchar(10)
AS
BEGIN
	DELETE MENU WHERE id_dish = @id_dish AND id_agency = 'ag_1'
	DELETE DISH WHERE id_dish = @id_dish
END