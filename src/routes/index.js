import { Router } from 'express';
import authController from '../controller/auth.controller.js';

const router = Router();

router.post('/register', authController.register);
router.post('/login', authController.login);

router.use('/bookings', BookingController);

router.post('/add-futsal-info', authenticateToken, FutsaladdController.addFutsalInfo);
router.get('/getFutsalInfo/:futsalId', authenticateToken, FutsaladdController.getFutsalInfo);

export default router;