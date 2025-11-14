import { Request, Response, NextFunction } from 'express';
import { config } from '@/config';
import { errorResponse } from '@/utils/response';

/**
 * @summary
 * Global error handling middleware.
 * Catches errors from route handlers and other middleware.
 */
export function errorMiddleware(
  err: Error,
  req: Request,
  res: Response,
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  next: NextFunction
): void {
  console.error(err.stack);

  const statusCode = 500;
  const message = 'InternalServerError';
  const details = config.env === 'development' ? err.message : undefined;

  res.status(statusCode).json(errorResponse(message, statusCode, details));
}
