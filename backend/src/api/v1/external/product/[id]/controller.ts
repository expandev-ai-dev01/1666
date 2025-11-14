import { Request, Response, NextFunction } from 'express';
import { z } from 'zod';

import { productGet } from '@/services/product/productRules';
import { successResponse } from '@/utils/response';
import { notFoundMiddleware } from '@/middleware/notFoundMiddleware';

export const getProductSchema = z.object({
  params: z.object({
    id: z.coerce.number().int().positive(),
  }),
});

/**
 * @api {get} /external/product/:id Get Product Details
 * @apiName GetProductDetails
 * @apiGroup Product
 * @apiVersion 1.0.0
 *
 * @apiDescription Retrieves detailed information for a single product.
 *
 * @apiParam {Number} id Product's unique ID.
 */
export async function getHandler(req: Request, res: Response, next: NextFunction): Promise<void> {
  try {
    const { params } = getProductSchema.parse(req);

    // Assuming idAccount=1 for this public-facing example.
    const product = await productGet({ idAccount: 1, idProduct: params.id });

    if (!product) {
      return notFoundMiddleware(req, res);
    }

    res.status(200).json(successResponse(product));
  } catch (error) {
    next(error);
  }
}
