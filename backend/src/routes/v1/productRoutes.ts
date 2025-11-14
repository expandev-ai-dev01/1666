import { Router } from 'express';
import * as productListController from '@/api/v1/external/product/controller';
import * as productDetailController from '@/api/v1/external/product/[id]/controller';
import * as productRelatedController from '@/api/v1/external/product/[id]/related/controller';

const router = Router();

router.get('/', productListController.listHandler);
router.get('/:id', productDetailController.getHandler);
router.get('/:id/related', productRelatedController.listHandler);

export default router;
