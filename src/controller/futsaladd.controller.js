import { PrismaClient } from '@prisma/client';
import HttpException from '../models/http-exception.model.js';

const prisma = new PrismaClient();

class FutsalController {

  static validatePan(pan) {
    const panRegex = /^\d{9}$/;
    return panRegex.test(pan);
  }

  

  async addFutsalInfo(req, res, next) {
    const { name, phone, address, type, startTime, endTime, amenities = [], stdPrice, rating = 0.0, pan } = req.body;

    if (!FutsalController.validatePan(pan)) {
      return next(new HttpException(400, 'PAN number must be exactly 9 digits and contain only numbers'));
    }

    if (!name || !phone || !address || !type || !startTime || !endTime || !stdPrice || !pan) {
      return next(new HttpException(400, 'All fields are required'));
    }

    if (!req.user || !req.user.userId) {
      return next(new HttpException(401, 'User not authenticated'));
    }

    try {
      const checkUser = await prisma.users.findUnique({
        where: { id: req.user.userId },
        include: { roles: true }
      });

      if (!checkUser) throw new HttpException(404, 'User not found');
      if (checkUser.roles.title.toLowerCase() !== 'futsal admin') throw new HttpException(401, 'Unauthorized access');

      const checkFutsal = await prisma.futsals.findUnique({
        where: { phone }
      });

      if (checkFutsal) throw new HttpException(400, 'Phone already registered');

      const checkPan = await prisma.futsals.findUnique({
        where: { pan }
      });

      if (checkPan) throw new HttpException(400, 'PAN already registered');

      const futsal = await prisma.futsals.create({
        data: {
          name,
          phone,
          address,
          type,
          startTime: new Date(startTime),
          endTime: new Date(endTime),
          amenities,
          stdPrice: parseInt(stdPrice, 10),
          rating: parseFloat(rating),
          pan,
          userId: req.user.userId,
        },
      });

      res.status(201).json({ message: 'Futsal information added successfully', result: futsal });
    } catch (error) {
      next(error);
    }
  }

  async getFutsalInfo(req, res, next){
    const{futsalId}=req.params;

    if(!futsalId){
        return next(new HttpException(400, "Futsal Id is required"))
    }   

    try{
        const futsal=await prisma.futsals.findUnique({
            where:{id:parseInt(futsalId,10)}
        })

        if (!futsal){
            return next(new HttpException(404, "futsal not found"))
        }
        res.status(200).json({ message: 'Futsal information retrieved successfully', result: futsal });
    } catch (error) {
      next(error);
    }    
  }

  async deleteFutsalInfo(req, res, next) {
    const { id } = req.params;

    if (!id) {
      return next(new HttpException(400, 'Futsal ID is required'));
    }

    try {
      const futsal = await prisma.futsals.findUnique({
        where: { id: parseInt(id, 10) }
      });

      if (!futsal) {
        return next(new HttpException(404, 'Futsal not found'));
      }

      await prisma.futsals.delete({
        where: { id: parseInt(id, 10) }
      });

      res.status(200).json({ message: 'Futsal information deleted successfully' });
    } catch (error) {
      next(error);
    }
  }
}

export default new FutsalController();
