/**
 * @summary
 * Retrieves a list of products related to a given product, primarily by category.
 * 
 * @procedure spProductRelatedList
 * @schema functional
 * @type stored-procedure
 * 
 * @endpoints
 * - GET /api/v1/external/product/{id}/related
 * 
 * @parameters
 * @param {INT} idAccount - Account identifier.
 * @param {INT} idProduct - The ID of the product to find related items for.
 * @param {INT} count - The maximum number of related products to return.
 */
CREATE OR ALTER PROCEDURE [functional].[spProductRelatedList]
    @idAccount INT,
    @idProduct INT,
    @count INT = 4
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @idCategory INT;

    -- Find the category of the reference product
    SELECT @idCategory = [prd].[idCategory]
    FROM [functional].[product] [prd]
    WHERE [prd].[idAccount] = @idAccount
      AND [prd].[idProduct] = @idProduct;

    -- Select related products from the same category
    SELECT TOP (@count)
        [prd].[idProduct],
        [prd].[name],
        [prd].[basePrice],
        [pim].[imageUrl] AS [primaryImageUrl],
        ISNULL([revStats].[averageRating], 0.0) AS [averageRating]
    FROM [functional].[product] [prd]
    LEFT JOIN [functional].[productImage] [pim] ON ([pim].[idAccount] = [prd].[idAccount] AND [pim].[idProduct] = [prd].[idProduct] AND [pim].[isPrimary] = 1 AND [pim].[deleted] = 0)
    LEFT JOIN (
        SELECT 
            [prv].[idProduct], 
            AVG(CAST([prv].[rating] AS DECIMAL(3,1))) AS [averageRating]
        FROM [functional].[productReview] [prv]
        WHERE [prv].[idAccount] = @idAccount AND [prv].[deleted] = 0
        GROUP BY [prv].[idProduct]
    ) [revStats] ON ([revStats].[idProduct] = [prd].[idProduct])
    WHERE [prd].[idAccount] = @idAccount
      AND [prd].[idCategory] = @idCategory
      AND [prd].[idProduct] <> @idProduct -- Exclude the product itself
      AND [prd].[deleted] = 0
      AND [prd].[active] = 1
    ORDER BY [revStats].[averageRating] DESC, [prd].[dateCreated] DESC;

END;
GO
