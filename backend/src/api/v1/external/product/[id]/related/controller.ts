import { Request, Response, NextFunction } from 'express';
import { z } from 'zod';

import { productRelatedList } from '@/services/product/productRules';
import { successResponse } from '@/utils/response';

export const getRelatedSchema = z.object({
  params: z.object({
    id: z.coerce.number().int().positive(),
  }),
  query: z.object({
    count: z.coerce.number().int().positive().optional().default(4),
  }),
});

/**
 * @api {get} /external/product/:id/related Get Related Products
 * @apiName GetRelatedProducts
 * @apiGroup Product
 * @apiVersion 1.0.0
 *
 * @apiDescription Retrieves a list of products related to the specified product.
 *
 * @apiParam {Number} id Product's unique ID.
 * @apiParam {Number} [count=4] Number of related products to return.
 */
export async function listHandler(req: Request, res: Response, next: NextFunction): Promise<void> {
  try {
    const { params, query } = getRelatedSchema.parse(req);

    // Assuming idAccount=1 for this public-facing example.
    const relatedProducts = await productRelatedList({
      idAccount: 1,
      idProduct: params.id,
      count: query.count,
    });

    res.status(200).json(successResponse(relatedProducts));
  } catch (error) {
    next(error);
  }
}
