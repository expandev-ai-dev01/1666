import { Request, Response, NextFunction } from 'express';

/**
 * @summary
 * Placeholder for authentication middleware.
 * CRITICAL: This is a passthrough and does NOT provide any security.
 * Authentication logic (e.g., JWT validation) must be implemented here.
 */
export async function authMiddleware(
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> {
  // TODO: Implement actual authentication logic here.
  // 1. Extract token from Authorization header.
  // 2. Verify the token.
  // 3. Decode the token to get user/account info.
  // 4. Attach user info to the request object (e.g., req.user).
  // 5. If invalid, send a 401 Unauthorized response.

  console.warn('WARNING: authMiddleware is a placeholder and provides no security.');

  // For now, we just pass through.
  next();
}
