import { Request, Response, NextFunction } from 'express';
import { z } from 'zod';

import { productList } from '@/services/product/productRules';
import { successResponse } from '@/utils/response';
import { ProductListParams } from '@/services/product/productTypes';

export const listProductsSchema = z.object({
  query: z.object({
    page: z.coerce.number().int().positive().optional().default(1),
    pageSize: z.coerce.number().int().positive().optional().default(12),
    orderBy: z
      .enum(['relevance', 'price_asc', 'price_desc', 'rating_desc', 'newest'])
      .optional()
      .default('relevance'),
    categoryIds: z.string().optional(), // Expects a comma-separated string of numbers
    flavorIds: z.string().optional(),
    priceMin: z.coerce.number().nonnegative().optional(),
    priceMax: z.coerce.number().positive().optional(),
    searchTerm: z.string().max(100).optional(),
  }),
});

/**
 * @api {get} /external/product List Products
 * @apiName ListProducts
 * @apiGroup Product
 * @apiVersion 1.0.0
 *
 * @apiDescription Retrieves a paginated list of products for the public catalog.
 *
 * @apiParam {Number} [page=1] Page number.
 * @apiParam {Number} [pageSize=12] Number of products per page.
 * @apiParam {String} [orderBy=relevance] Sort order.
 * @apiParam {String} [categoryIds] Comma-separated category IDs.
 * @apiParam {String} [flavorIds] Comma-separated flavor IDs.
 * @apiParam {Number} [priceMin] Minimum price.
 * @apiParam {Number} [priceMax] Maximum price.
 * @apiParam {String} [searchTerm] Search term.
 */
export async function listHandler(req: Request, res: Response, next: NextFunction): Promise<void> {
  try {
    const { query } = listProductsSchema.parse(req);

    // Assuming idAccount=1 for this public-facing example.
    // In a real multi-tenant app, this might come from the domain, a header, etc.
    const params: ProductListParams = {
      idAccount: 1,
      pageNumber: query.page,
      pageSize: query.pageSize,
      orderBy: query.orderBy,
      categoryIds: query.categoryIds
        ? JSON.stringify(query.categoryIds.split(',').map(Number))
        : undefined,
      flavorIds: query.flavorIds
        ? JSON.stringify(query.flavorIds.split(',').map(Number))
        : undefined,
      priceMin: query.priceMin,
      priceMax: query.priceMax,
      searchTerm: query.searchTerm,
    };

    const { products, total } = await productList(params);

    const metadata = {
      page: query.page,
      pageSize: query.pageSize,
      totalItems: total,
      totalPages: Math.ceil(total / query.pageSize),
    };

    res.status(200).json(successResponse(products, metadata));
  } catch (error) {
    next(error);
  }
}
