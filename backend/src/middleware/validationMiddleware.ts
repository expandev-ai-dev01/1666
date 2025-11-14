import { Request, Response, NextFunction } from 'express';
import { z, ZodError } from 'zod';
import { errorResponse } from '@/utils/response';

/**
 * @summary
 * Creates a middleware for validating request body, params, or query using a Zod schema.
 * @param schema The Zod schema to validate against.
 * @returns An Express middleware function.
 */
export const validationMiddleware =
  (schema: z.ZodObject<any, any, any>) =>
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      await schema.parseAsync({
        body: req.body,
        query: req.query,
        params: req.params,
      });
      return next();
    } catch (error) {
      if (error instanceof ZodError) {
        const details = error.errors.map((e) => ({
          path: e.path.join('.'),
          message: e.message,
        }));
        return res.status(400).json(errorResponse('ValidationFailed', 400, details));
      }
      return res.status(500).json(errorResponse('InternalServerError', 500));
    }
  };
