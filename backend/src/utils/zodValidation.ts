import { z } from 'zod';

/**
 * @summary
 * This file contains reusable Zod schemas for common data types and validation rules.
 */

// Example of a reusable schema for a foreign key ID
export const zFk = z.number().int().positive({ message: 'Must be a positive integer' });
export const zNullableFk = zFk.nullable();

// Example for a standard name field
export const zName = z.string().min(1, { message: 'Name cannot be empty' }).max(100);

// Example for a description field
export const zDescription = z.string().max(500);
export const zNullableDescription = zDescription.nullable();
