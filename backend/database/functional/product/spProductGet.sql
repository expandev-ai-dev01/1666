/**
 * @summary
 * Retrieves all details for a single product, returning multiple result sets for the backend to assemble.
 * 
 * @procedure spProductGet
 * @schema functional
 * @type stored-procedure
 * 
 * @endpoints
 * - GET /api/v1/external/product/{id}
 * 
 * @parameters
 * @param {INT} idAccount 
 *   - Required: Yes
 *   - Description: The account identifier.
 * @param {INT} idProduct
 *   - Required: Yes
 *   - Description: The unique identifier of the product to retrieve.
 */
CREATE OR ALTER PROCEDURE [functional].[spProductGet]
  @idAccount INT,
  @idProduct INT
AS
BEGIN
  SET NOCOUNT ON;

  /**
   * @output {ProductDetails, 1, n}
   * @column {INT} idProduct
   * @column {NVARCHAR} name
   * @column {NVARCHAR} description
   * @column {NVARCHAR} ingredientsJson
   * @column {NUMERIC} basePrice
   * @column {NVARCHAR} preparationTime
   * @column {INT} idCategory
   * @column {NVARCHAR} categoryName
   * @column {INT} idConfectioner
   * @column {NVARCHAR} confectionerName
   * @column {NVARCHAR} confectionerImageUrl
   * @column {DECIMAL} averageRating
   * @column {INT} reviewCount
   */
  SELECT
    [prd].[idProduct],
    [prd].[name],
    [prd].[description],
    [prd].[ingredientsJson],
    [prd].[basePrice],
    [prd].[preparationTime],
    [prd].[idCategory],
    [ctg].[name] AS [categoryName],
    [prd].[idConfectioner],
    [cnf].[name] AS [confectionerName],
    [cnf].[imageUrl] AS [confectionerImageUrl],
    ISNULL(revStats.averageRating, 0.0) AS [averageRating],
    ISNULL(revStats.reviewCount, 0) AS [reviewCount]
  FROM [functional].[product] [prd]
  JOIN [functional].[category] [ctg] ON ([ctg].[idAccount] = [prd].[idAccount] AND [ctg].[idCategory] = [prd].[idCategory])
  JOIN [functional].[confectioner] [cnf] ON ([cnf].[idAccount] = [prd].[idAccount] AND [cnf].[idConfectioner] = [prd].[idConfectioner])
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
    AND [prd].[idProduct] = @idProduct
    AND [prd].[deleted] = 0
    AND [prd].[active] = 1;

  /**
   * @output {ProductImages, n, n}
   * @column {INT} idProductImage
   * @column {NVARCHAR} imageUrl
   * @column {BIT} isPrimary
   */
  SELECT
    [pim].[idProductImage],
    [pim].[imageUrl],
    [pim].[isPrimary]
  FROM [functional].[productImage] [pim]
  WHERE [pim].[idAccount] = @idAccount
    AND [pim].[idProduct] = @idProduct
    AND [pim].[deleted] = 0
  ORDER BY [pim].[isPrimary] DESC;

  /**
   * @output {ProductFlavors, n, n}
   * @column {INT} idFlavor
   * @column {NVARCHAR} name
   */
  SELECT
    [flv].[idFlavor],
    [flv].[name]
  FROM [functional].[flavor] [flv]
  JOIN [functional].[productFlavor] [pfl] ON ([pfl].[idAccount] = [flv].[idAccount] AND [pfl].[idFlavor] = [flv].[idFlavor])
  WHERE [pfl].[idAccount] = @idAccount
    AND [pfl].[idProduct] = @idProduct
    AND [flv].[deleted] = 0;

  /**
   * @output {ProductSizes, n, n}
   * @column {INT} idProductSize
   * @column {NVARCHAR} name
   * @column {NVARCHAR} description
   * @column {NUMERIC} priceModifier
   */
  SELECT
    [psz].[idProductSize],
    [psz].[name],
    [psz].[description],
    [psz].[priceModifier]
  FROM [functional].[productSize] [psz]
  WHERE [psz].[idAccount] = @idAccount
    AND [psz].[idProduct] = @idProduct
    AND [psz].[deleted] = 0;

  /**
   * @output {ProductReviews, n, n}
   * @column {INT} idProductReview
   * @column {NVARCHAR} customerName
   * @column {TINYINT} rating
   * @column {NVARCHAR} comment
   * @column {DATETIME2} dateCreated
   */
  SELECT
    [prv].[idProductReview],
    [prv].[customerName],
    [prv].[rating],
    [prv].[comment],
    [prv].[dateCreated]
  FROM [functional].[productReview] [prv]
  WHERE [prv].[idAccount] = @idAccount
    AND [prv].[idProduct] = @idProduct
    AND [prv].[deleted] = 0
  ORDER BY [prv].[dateCreated] DESC;

END;
GO
