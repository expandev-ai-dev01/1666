/**
 * @summary
 * V1 API router that aggregates external and internal routes.
 */
import { Router } from 'express';
import externalRoutes from './externalRoutes';
import internalRoutes from './internalRoutes';

const router = Router();

// Publicly accessible routes
router.use('/external', externalRoutes);

// Routes requiring authentication
router.use('/internal', internalRoutes);

export default router;
