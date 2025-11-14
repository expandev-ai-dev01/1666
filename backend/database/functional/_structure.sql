/**
 * @schema functional
 * Contains tables and logic related to the core business features and entities of the application.
 */
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'functional')
BEGIN
    EXEC('CREATE SCHEMA functional');
END
GO

-- Add business entity tables here as features are developed.
-- Example for a 'Product' feature:
/*
CREATE TABLE [functional].[product] (
  [idProduct] INTEGER IDENTITY(1,1) NOT NULL,
  [idAccount] INTEGER NOT NULL,
  [name] NVARCHAR(100) NOT NULL,
  [description] NVARCHAR(500) NOT NULL DEFAULT (''),
  [price] NUMERIC(18,6) NOT NULL,
  [deleted] BIT NOT NULL DEFAULT (0)
);
*/
