/**
 * @summary
 * Main API router that delegates to version-specific routers.
 */
import { Router } from 'express';
import v1Routes from './v1';

const router = Router();

// Mount V1 routes
router.use('/v1', v1Routes);

// Future versions can be added here
// router.use('/v2', v2Routes);

export default router;
