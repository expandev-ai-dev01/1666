/**
 * @summary
 * Defines all external (public) API routes for V1.
 * These routes do not require authentication.
 */
import { Router } from 'express';
import productRoutes from './productRoutes';

const router = Router();

// [+] INTEGRATION POINT: Add external feature routes here
router.use('/product', productRoutes);

export default router;
