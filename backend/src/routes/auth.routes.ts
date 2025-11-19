import { Router } from 'express';
import {
  loginController,
  meController,
  registerController,
  verifyEmailController,
} from '../controllers/auth.controller';
import { authMiddleware, roleMiddleware } from '../middleware/auth';
import { UserRole } from '@prisma/client';

const router = Router();

router.post('/login', loginController);
router.post('/register', authMiddleware, roleMiddleware([UserRole.ADMIN]), registerController);
router.get('/verify-email', verifyEmailController);
router.get('/me', authMiddleware, roleMiddleware([UserRole.ADMIN]), meController);

export default router;
