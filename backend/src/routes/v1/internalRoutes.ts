/**
 * @summary
 * Defines all internal (protected) API routes for V1.
 * These routes will be protected by authentication middleware.
 */
import { Router } from 'express';
import { authMiddleware } from '@/middleware/authMiddleware';

const router = Router();

// Apply authentication middleware to all internal routes
router.use(authMiddleware);

// [+] INTEGRATION POINT: Add internal feature routes here
// Example: router.use('/orders', orderRoutes);

export default router;
