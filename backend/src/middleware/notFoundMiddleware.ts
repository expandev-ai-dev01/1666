import { Request, Response } from 'express';
import { errorResponse } from '@/utils/response';

/**
 * @summary
 * Middleware to handle requests for routes that do not exist.
 */
export function notFoundMiddleware(req: Request, res: Response): void {
  const message = `RouteNotFound: Cannot ${req.method} ${req.originalUrl}`;
  res.status(404).json(errorResponse(message, 404));
}
