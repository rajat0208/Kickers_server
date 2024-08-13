import { Router } from 'express';
import HttpException from '../models/http-exception.model.js';
import authenticateToken from '../middleware/auth.middleware.js';
import { createBooking } from '../service/booking.service.js';
const router = Router();

router.post('/', authenticateToken, async (req, res, next) => {
    try {
        const userId = req.user.userId;
        if (!userId) throw new HttpException(400, "User id not provided");
        const response = await createBooking(req.body, userId);
        res.status(201).json({
            msg: "Booking created",
            result: response,
        });
    } catch (error) {
        next(error);
    }
});

export default router;
