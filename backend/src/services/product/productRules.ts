import { dbRequest } from '@/utils/database';
import {
  ProductListParams,
  ProductGetParams,
  ProductRelatedListParams,
  ProductListItem,
  ProductDetail,
  ProductImage,
  ProductFlavor,
  ProductSize,
  ProductReview,
  ProductRelatedItem,
} from './productTypes';

/**
 * @summary
 * Fetches a paginated list of products based on filter criteria.
 * @param {ProductListParams} params - The filtering, sorting, and pagination parameters.
 * @returns {Promise<{ products: ProductListItem[], total: number }>} A list of products and the total count.
 */
export async function productList(
  params: ProductListParams
): Promise<{ products: ProductListItem[]; total: number }> {
  const result = await dbRequest('[functional].[spProductList]', params);
  const products = result[0] || [];
  const total = products.length > 0 ? products[0].total : 0;

  // Remove the 'total' property from each product object
  const cleanedProducts = products.map(({ total, ...rest }) => rest);

  return { products: cleanedProducts, total };
}

/**
 * @summary
 * Fetches the detailed information for a single product.
 * @param {ProductGetParams} params - The product and account identifiers.
 * @returns {Promise<ProductDetail | null>} The detailed product object or null if not found.
 */
export async function productGet(params: ProductGetParams): Promise<ProductDetail | null> {
  const resultSets = await dbRequest('[functional].[spProductGet]', params);

  const productDetails = resultSets[0]?.[0];
  if (!productDetails) {
    return null;
  }

  const product: ProductDetail = {
    ...productDetails,
    ingredients: JSON.parse(productDetails.ingredientsJson || '[]'),
    images: resultSets[1] as ProductImage[],
    flavors: resultSets[2] as ProductFlavor[],
    sizes: resultSets[3] as ProductSize[],
    reviews: resultSets[4] as ProductReview[],
  };

  return product;
}

/**
 * @summary
 * Fetches a list of products related to a given product.
 * @param {ProductRelatedListParams} params - The reference product ID and desired count.
 * @returns {Promise<ProductRelatedItem[]>} A list of related products.
 */
export async function productRelatedList(
  params: ProductRelatedListParams
): Promise<ProductRelatedItem[]> {
  const result = await dbRequest('[functional].[spProductRelatedList]', params);
  return result[0] || [];
}
