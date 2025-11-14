/**
 * @summary
 * Retrieves a paginated and filtered list of products for the catalog.
 * 
 * @procedure spProductList
 * @schema functional
 * @type stored-procedure
 * 
 * @endpoints
 * - GET /api/v1/external/product
 * 
 * @parameters
 * @param {INT} idAccount - Account identifier.
 * @param {INT} pageNumber - The page number to retrieve.
 * @param {INT} pageSize - The number of items per page.
 * @param {NVARCHAR(50)} orderBy - The sorting criteria.
 * @param {NVARCHAR(MAX)} categoryIds - JSON array of category IDs to filter by.
 * @param {NVARCHAR(MAX)} flavorIds - JSON array of flavor IDs to filter by.
 * @param {NUMERIC(18,6)} priceMin - Minimum price filter.
 * @param {NUMERIC(18,6)} priceMax - Maximum price filter.
 * @param {NVARCHAR(100)} searchTerm - Text to search in name and description.
 */
CREATE OR ALTER PROCEDURE [functional].[spProductList]
    @idAccount INT,
    @pageNumber INT = 1,
    @pageSize INT = 12,
    @orderBy NVARCHAR(50) = 'relevance',
    @categoryIds NVARCHAR(MAX) = NULL,
    @flavorIds NVARCHAR(MAX) = NULL,
    @priceMin NUMERIC(18, 6) = NULL,
    @priceMax NUMERIC(18, 6) = NULL,
    @searchTerm NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- CTE for filtering and joining data
    WITH ProductData AS (
        SELECT
            [prd].[idProduct],
            [prd].[name],
            [prd].[basePrice],
            [prd].[preparationTime],
            [cnf].[name] AS [confectionerName],
            [pim].[imageUrl] AS [primaryImageUrl],
            ISNULL([revStats].[averageRating], 0.0) AS [averageRating],
            ISNULL([revStats].[reviewCount], 0) AS [reviewCount],
            [prd].[dateCreated]
        FROM [functional].[product] [prd]
        JOIN [functional].[confectioner] [cnf] ON ([cnf].[idAccount] = [prd].[idAccount] AND [cnf].[idConfectioner] = [prd].[idConfectioner])
        LEFT JOIN [functional].[productImage] [pim] ON ([pim].[idAccount] = [prd].[idAccount] AND [pim].[idProduct] = [prd].[idProduct] AND [pim].[isPrimary] = 1 AND [pim].[deleted] = 0)
        LEFT JOIN (
            SELECT 
                [prv].[idProduct], 
                AVG(CAST([prv].[rating] AS DECIMAL(3,1))) AS [averageRating], 
                COUNT([prv].[idProductReview]) AS [reviewCount]
            FROM [functional].[productReview] [prv]
            WHERE [prv].[idAccount] = @idAccount AND [prv].[deleted] = 0
            GROUP BY [prv].[idProduct]
        ) [revStats] ON ([revStats].[idProduct] = [prd].[idProduct])
        WHERE [prd].[idAccount] = @idAccount
          AND [prd].[deleted] = 0
          AND [prd].[active] = 1
          -- Search Term Filter
          AND (@searchTerm IS NULL OR [prd].[name] LIKE '%' + @searchTerm + '%' OR [prd].[description] LIKE '%' + @searchTerm + '%')
          -- Price Filter
          AND (@priceMin IS NULL OR [prd].[basePrice] >= @priceMin)
          AND (@priceMax IS NULL OR [prd].[basePrice] <= @priceMax)
          -- Category Filter
          AND (@categoryIds IS NULL OR [prd].[idCategory] IN (SELECT CAST(value AS INT) FROM OPENJSON(@categoryIds)))
          -- Flavor Filter
          AND (@flavorIds IS NULL OR EXISTS (
              SELECT 1 FROM [functional].[productFlavor] [pfl]
              WHERE [pfl].[idAccount] = @idAccount
                AND [pfl].[idProduct] = [prd].[idProduct]
                AND [pfl].[idFlavor] IN (SELECT CAST(value AS INT) FROM OPENJSON(@flavorIds))
          ))
    ),
    -- CTE for counting total records after filtering
    TotalCount AS (
        SELECT COUNT(*) AS [total] FROM ProductData
    )
    -- Final SELECT with ordering and pagination
    SELECT
        [pd].*,
        [tc].[total]
    FROM ProductData [pd], TotalCount [tc]
    ORDER BY
        CASE WHEN @orderBy = 'relevance' THEN [pd].[reviewCount] END DESC,
        CASE WHEN @orderBy = 'price_asc' THEN [pd].[basePrice] END ASC,
        CASE WHEN @orderBy = 'price_desc' THEN [pd].[basePrice] END DESC,
        CASE WHEN @orderBy = 'rating_desc' THEN [pd].[averageRating] END DESC,
        CASE WHEN @orderBy = 'newest' THEN [pd].[dateCreated] END DESC,
        [pd].[idProduct] ASC -- Default sort for stable pagination
    OFFSET (@pageNumber - 1) * @pageSize ROWS
    FETCH NEXT @pageSize ROWS ONLY;

END;
GO
