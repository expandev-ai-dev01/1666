/**
 * @schema security
 * Contains tables and logic for authentication, authorization, users, and permissions.
 */
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'security')
BEGIN
    EXEC('CREATE SCHEMA security');
END
GO

-- Add security-related tables here.
-- Example:
/*
CREATE TABLE [security].[user] (
  [idUser] INTEGER IDENTITY(1,1) NOT NULL,
  [idAccount] INTEGER NOT NULL,
  [email] NVARCHAR(255) NOT NULL,
  [passwordHash] NVARCHAR(255) NOT NULL,
  [deleted] BIT NOT NULL DEFAULT (0)
);
*/
