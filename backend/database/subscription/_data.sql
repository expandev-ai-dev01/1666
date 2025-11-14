-- Seed data for the 'subscription' schema.
-- This file can contain a default account for single-tenant setups or initial subscription plans.

/**
 * @load {account}
 */
-- It's good practice to have at least one default account.
SET IDENTITY_INSERT [subscription].[account] ON;
INSERT INTO [subscription].[account] ([idAccount], [name])
VALUES (1, 'Default Account');
SET IDENTITY_INSERT [subscription].[account] OFF;
