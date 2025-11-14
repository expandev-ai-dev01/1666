/**
 * @schema subscription
 * Contains tables and logic for managing accounts, subscriptions, and multi-tenancy.
 */
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'subscription')
BEGIN
    EXEC('CREATE SCHEMA subscription');
END
GO

-- This table is fundamental for multi-tenancy.
CREATE TABLE [subscription].[account] (
  [idAccount] INTEGER IDENTITY(1,1) NOT NULL,
  [name] NVARCHAR(100) NOT NULL,
  [dateCreated] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
  [deleted] BIT NOT NULL DEFAULT (0)
);

ALTER TABLE [subscription].[account]
ADD CONSTRAINT [pkAccount] PRIMARY KEY CLUSTERED ([idAccount]);
GO
