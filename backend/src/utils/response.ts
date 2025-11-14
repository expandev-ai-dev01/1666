/**
 * @summary
 * Standardized success response format.
 * @param data The payload to be returned.
 * @param metadata Optional metadata (e.g., for pagination).
 */
export const successResponse = <T>(data: T, metadata?: object) => ({
  success: true,
  data,
  metadata: {
    ...metadata,
    timestamp: new Date().toISOString(),
  },
});

/**
 * @summary
 * Standardized error response format.
 * @param message A mnemonic error message or code.
 * @param statusCode The HTTP status code.
 * @param details Optional details about the error (e.g., validation issues).
 */
export const errorResponse = (message: string, statusCode: number, details?: any) => ({
  success: false,
  error: {
    code: statusCode,
    message,
    details,
  },
  timestamp: new Date().toISOString(),
});
