/**
 * @schema functional
 * Contains tables and logic related to the core business features and entities of the application.
 */
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'functional')
BEGIN
    EXEC('CREATE SCHEMA functional');
END
GO

-- =============================================
-- Confectioner Table
-- =============================================
/**
 * @table {confectioner} Stores information about the cake makers/sellers.
 * @multitenancy true
 * @softDelete true
 * @alias cnf
 */
CREATE TABLE [functional].[confectioner] (
  [idConfectioner] INTEGER IDENTITY(1, 1) NOT NULL,
  [idAccount] INTEGER NOT NULL,
  [name] NVARCHAR(100) NOT NULL,
  [imageUrl] NVARCHAR(255) NULL,
  [dateCreated] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
  [deleted] BIT NOT NULL DEFAULT (0)
);
GO

-- =============================================
-- Category Table
-- =============================================
/**
 * @table {category} Stores product categories (e.g., Wedding Cakes, Birthday Cakes).
 * @multitenancy true
 * @softDelete true
 * @alias ctg
 */
CREATE TABLE [functional].[category] (
  [idCategory] INTEGER IDENTITY(1, 1) NOT NULL,
  [idAccount] INTEGER NOT NULL,
  [name] NVARCHAR(100) NOT NULL,
  [description] NVARCHAR(500) NOT NULL DEFAULT (''),
  [dateCreated] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
  [deleted] BIT NOT NULL DEFAULT (0)
);
GO

-- =============================================
-- Flavor Table
-- =============================================
/**
 * @table {flavor} Stores available cake flavors.
 * @multitenancy true
 * @softDelete true
 * @alias flv
 */
CREATE TABLE [functional].[flavor] (
  [idFlavor] INTEGER IDENTITY(1, 1) NOT NULL,
  [idAccount] INTEGER NOT NULL,
  [name] NVARCHAR(100) NOT NULL,
  [deleted] BIT NOT NULL DEFAULT (0)
);
GO

-- =============================================
-- Product Table
-- =============================================
/**
 * @table {product} Core table for storing cake products.
 * @multitenancy true
 * @softDelete true
 * @alias prd
 */
CREATE TABLE [functional].[product] (
  [idProduct] INTEGER IDENTITY(1, 1) NOT NULL,
  [idAccount] INTEGER NOT NULL,
  [idCategory] INTEGER NOT NULL,
  [idConfectioner] INTEGER NOT NULL,
  [name] NVARCHAR(100) NOT NULL,
  [description] NVARCHAR(1000) NOT NULL DEFAULT (''),
  [ingredientsJson] NVARCHAR(MAX) NULL, -- Storing as JSON array of strings
  [basePrice] NUMERIC(18, 6) NOT NULL,
  [preparationTime] NVARCHAR(50) NOT NULL, -- e.g., '2 dias', '24 horas'
  [active] BIT NOT NULL DEFAULT (1),
  [dateCreated] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
  [dateModified] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
  [deleted] BIT NOT NULL DEFAULT (0)
);
GO

-- =============================================
-- ProductSize Table
-- =============================================
/**
 * @table {productSize} Stores available sizes for a product and their price adjustments.
 * @multitenancy true
 * @softDelete true
 * @alias psz
 */
CREATE TABLE [functional].[productSize] (
  [idProductSize] INTEGER IDENTITY(1, 1) NOT NULL,
  [idAccount] INTEGER NOT NULL,
  [idProduct] INTEGER NOT NULL,
  [name] NVARCHAR(100) NOT NULL, -- e.g., 'Pequeno', '15cm'
  [description] NVARCHAR(255) NOT NULL DEFAULT (''), -- e.g., 'Serve 10 pessoas'
  [priceModifier] NUMERIC(18, 6) NOT NULL DEFAULT (0), -- Value to add to the base price
  [deleted] BIT NOT NULL DEFAULT (0)
);
GO

-- =============================================
-- ProductFlavor (Relationship Table)
-- =============================================
/**
 * @table {productFlavor} Maps which flavors are available for which products.
 * @multitenancy true
 * @softDelete false
 * @alias pfl
 */
CREATE TABLE [functional].[productFlavor] (
  [idAccount] INTEGER NOT NULL,
  [idProduct] INTEGER NOT NULL,
  [idFlavor] INTEGER NOT NULL
);
GO

-- =============================================
-- ProductImage Table
-- =============================================
/**
 * @table {productImage} Stores image URLs for a product gallery.
 * @multitenancy true
 * @softDelete true
 * @alias pim
 */
CREATE TABLE [functional].[productImage] (
  [idProductImage] INTEGER IDENTITY(1, 1) NOT NULL,
  [idAccount] INTEGER NOT NULL,
  [idProduct] INTEGER NOT NULL,
  [imageUrl] NVARCHAR(255) NOT NULL,
  [isPrimary] BIT NOT NULL DEFAULT (0),
  [deleted] BIT NOT NULL DEFAULT (0)
);
GO

-- =============================================
-- ProductReview Table
-- =============================================
/**
 * @table {productReview} Stores customer reviews for products.
 * @multitenancy true
 * @softDelete true
 * @alias prv
 */
CREATE TABLE [functional].[productReview] (
  [idProductReview] INTEGER IDENTITY(1, 1) NOT NULL,
  [idAccount] INTEGER NOT NULL,
  [idProduct] INTEGER NOT NULL,
  -- [idCustomer] INTEGER NOT NULL, -- Assuming a customer table exists elsewhere
  [customerName] NVARCHAR(100) NOT NULL, -- Placeholder until customer table is defined
  [rating] TINYINT NOT NULL, -- 1 to 5
  [comment] NVARCHAR(1000) NULL,
  [dateCreated] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
  [deleted] BIT NOT NULL DEFAULT (0)
);
GO

-- =============================================
-- CONSTRAINTS
-- =============================================

-- Confectioner
ALTER TABLE [functional].[confectioner] ADD CONSTRAINT [pkConfectioner] PRIMARY KEY CLUSTERED ([idConfectioner]);
ALTER TABLE [functional].[confectioner] ADD CONSTRAINT [fkConfectioner_Account] FOREIGN KEY ([idAccount]) REFERENCES [subscription].[account]([idAccount]);

-- Category
ALTER TABLE [functional].[category] ADD CONSTRAINT [pkCategory] PRIMARY KEY CLUSTERED ([idCategory]);
ALTER TABLE [functional].[category] ADD CONSTRAINT [fkCategory_Account] FOREIGN KEY ([idAccount]) REFERENCES [subscription].[account]([idAccount]);

-- Flavor
ALTER TABLE [functional].[flavor] ADD CONSTRAINT [pkFlavor] PRIMARY KEY CLUSTERED ([idFlavor]);
ALTER TABLE [functional].[flavor] ADD CONSTRAINT [fkFlavor_Account] FOREIGN KEY ([idAccount]) REFERENCES [subscription].[account]([idAccount]);

-- Product
ALTER TABLE [functional].[product] ADD CONSTRAINT [pkProduct] PRIMARY KEY CLUSTERED ([idProduct]);
ALTER TABLE [functional].[product] ADD CONSTRAINT [fkProduct_Account] FOREIGN KEY ([idAccount]) REFERENCES [subscription].[account]([idAccount]);
ALTER TABLE [functional].[product] ADD CONSTRAINT [fkProduct_Category] FOREIGN KEY ([idCategory]) REFERENCES [functional].[category]([idCategory]);
ALTER TABLE [functional].[product] ADD CONSTRAINT [fkProduct_Confectioner] FOREIGN KEY ([idConfectioner]) REFERENCES [functional].[confectioner]([idConfectioner]);

-- ProductSize
ALTER TABLE [functional].[productSize] ADD CONSTRAINT [pkProductSize] PRIMARY KEY CLUSTERED ([idProductSize]);
ALTER TABLE [functional].[productSize] ADD CONSTRAINT [fkProductSize_Account] FOREIGN KEY ([idAccount]) REFERENCES [subscription].[account]([idAccount]);
ALTER TABLE [functional].[productSize] ADD CONSTRAINT [fkProductSize_Product] FOREIGN KEY ([idProduct]) REFERENCES [functional].[product]([idProduct]);

-- ProductFlavor
ALTER TABLE [functional].[productFlavor] ADD CONSTRAINT [pkProductFlavor] PRIMARY KEY CLUSTERED ([idAccount], [idProduct], [idFlavor]);
ALTER TABLE [functional].[productFlavor] ADD CONSTRAINT [fkProductFlavor_Account] FOREIGN KEY ([idAccount]) REFERENCES [subscription].[account]([idAccount]);
ALTER TABLE [functional].[productFlavor] ADD CONSTRAINT [fkProductFlavor_Product] FOREIGN KEY ([idProduct]) REFERENCES [functional].[product]([idProduct]);
ALTER TABLE [functional].[productFlavor] ADD CONSTRAINT [fkProductFlavor_Flavor] FOREIGN KEY ([idFlavor]) REFERENCES [functional].[flavor]([idFlavor]);

-- ProductImage
ALTER TABLE [functional].[productImage] ADD CONSTRAINT [pkProductImage] PRIMARY KEY CLUSTERED ([idProductImage]);
ALTER TABLE [functional].[productImage] ADD CONSTRAINT [fkProductImage_Account] FOREIGN KEY ([idAccount]) REFERENCES [subscription].[account]([idAccount]);
ALTER TABLE [functional].[productImage] ADD CONSTRAINT [fkProductImage_Product] FOREIGN KEY ([idProduct]) REFERENCES [functional].[product]([idProduct]);

-- ProductReview
ALTER TABLE [functional].[productReview] ADD CONSTRAINT [pkProductReview] PRIMARY KEY CLUSTERED ([idProductReview]);
ALTER TABLE [functional].[productReview] ADD CONSTRAINT [fkProductReview_Account] FOREIGN KEY ([idAccount]) REFERENCES [subscription].[account]([idAccount]);
ALTER TABLE [functional].[productReview] ADD CONSTRAINT [fkProductReview_Product] FOREIGN KEY ([idProduct]) REFERENCES [functional].[product]([idProduct]);
ALTER TABLE [functional].[productReview] ADD CONSTRAINT [chkProductReview_Rating] CHECK ([rating] BETWEEN 1 AND 5);
GO

-- =============================================
-- INDEXES
-- =============================================

-- Confectioner
CREATE NONCLUSTERED INDEX [ixConfectioner_Account] ON [functional].[confectioner]([idAccount]) WHERE [deleted] = 0;
CREATE UNIQUE NONCLUSTERED INDEX [uqConfectioner_Account_Name] ON [functional].[confectioner]([idAccount], [name]) WHERE [deleted] = 0;

-- Category
CREATE NONCLUSTERED INDEX [ixCategory_Account] ON [functional].[category]([idAccount]) WHERE [deleted] = 0;
CREATE UNIQUE NONCLUSTERED INDEX [uqCategory_Account_Name] ON [functional].[category]([idAccount], [name]) WHERE [deleted] = 0;

-- Flavor
CREATE NONCLUSTERED INDEX [ixFlavor_Account] ON [functional].[flavor]([idAccount]) WHERE [deleted] = 0;
CREATE UNIQUE NONCLUSTERED INDEX [uqFlavor_Account_Name] ON [functional].[flavor]([idAccount], [name]) WHERE [deleted] = 0;

-- Product
CREATE NONCLUSTERED INDEX [ixProduct_Account] ON [functional].[product]([idAccount]) WHERE [deleted] = 0;
CREATE NONCLUSTERED INDEX [ixProduct_Account_Category] ON [functional].[product]([idAccount], [idCategory]) WHERE [deleted] = 0;
CREATE NONCLUSTERED INDEX [ixProduct_Account_Confectioner] ON [functional].[product]([idAccount], [idConfectioner]) WHERE [deleted] = 0;

-- ProductSize
CREATE NONCLUSTERED INDEX [ixProductSize_Account_Product] ON [functional].[productSize]([idAccount], [idProduct]) WHERE [deleted] = 0;

-- ProductImage
CREATE NONCLUSTERED INDEX [ixProductImage_Account_Product] ON [functional].[productImage]([idAccount], [idProduct]) WHERE [deleted] = 0;

-- ProductReview
CREATE NONCLUSTERED INDEX [ixProductReview_Account_Product] ON [functional].[productReview]([idAccount], [idProduct]) WHERE [deleted] = 0;
GO
