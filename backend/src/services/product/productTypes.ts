/**
 * @interface ProductListParams
 * @description Parameters for the product list service function.
 */
export interface ProductListParams {
  idAccount: number;
  pageNumber: number;
  pageSize: number;
  orderBy?: string;
  categoryIds?: string; // JSON array as string
  flavorIds?: string; // JSON array as string
  priceMin?: number;
  priceMax?: number;
  searchTerm?: string;
}

/**
 * @interface ProductGetParams
 * @description Parameters for fetching a single product's details.
 */
export interface ProductGetParams {
  idAccount: number;
  idProduct: number;
}

/**
 * @interface ProductRelatedListParams
 * @description Parameters for fetching related products.
 */
export interface ProductRelatedListParams {
  idAccount: number;
  idProduct: number;
  count: number;
}

/**
 * @interface ProductListItem
 * @description Represents a product in a catalog list (summary view).
 */
export interface ProductListItem {
  idProduct: number;
  name: string;
  basePrice: number;
  preparationTime: string;
  confectionerName: string;
  primaryImageUrl: string | null;
  averageRating: number;
  reviewCount: number;
}

/**
 * @interface ProductImage
 * @description Represents an image in the product gallery.
 */
export interface ProductImage {
  idProductImage: number;
  imageUrl: string;
  isPrimary: boolean;
}

/**
 * @interface ProductFlavor
 * @description Represents an available flavor for a product.
 */
export interface ProductFlavor {
  idFlavor: number;
  name: string;
}

/**
 * @interface ProductSize
 * @description Represents an available size for a product.
 */
export interface ProductSize {
  idProductSize: number;
  name: string;
  description: string;
  priceModifier: number;
}

/**
 * @interface ProductReview
 * @description Represents a customer review for a product.
 */
export interface ProductReview {
  idProductReview: number;
  customerName: string;
  rating: number;
  comment: string | null;
  dateCreated: Date;
}

/**
 * @interface ProductDetail
 * @description Represents the full details of a single product.
 */
export interface ProductDetail {
  idProduct: number;
  name: string;
  description: string;
  ingredients: string[];
  basePrice: number;
  preparationTime: string;
  idCategory: number;
  categoryName: string;
  idConfectioner: number;
  confectionerName: string;
  confectionerImageUrl: string | null;
  averageRating: number;
  reviewCount: number;
  images: ProductImage[];
  flavors: ProductFlavor[];
  sizes: ProductSize[];
  reviews: ProductReview[];
}

/**
 * @interface ProductRelatedItem
 * @description Represents a product in the related products list.
 */
export interface ProductRelatedItem {
  idProduct: number;
  name: string;
  basePrice: number;
  primaryImageUrl: string | null;
  averageRating: number;
}
