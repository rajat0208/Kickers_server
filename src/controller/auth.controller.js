import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { PrismaClient } from '@prisma/client';
import multer from 'multer';
import path from 'path';
import { fileURLToPath } from 'url';
import { dirname } from 'path';
import HttpException from '../models/http-exception.model.js';
import { registerValidation } from '../middleware/authValidation.middleware.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
const prisma = new PrismaClient();
const JWT_SECRET = process.env.JWT_SECRET;

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, path.join(__dirname, '../assets/user-images'));
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + path.extname(file.originalname));
  }
});

const upload = multer({ storage: storage });

class AuthController {
  register = [
    upload.single('image'),
    registerValidation,
    async (req, res, next) => {
      const { name, email, phone, address, password, roleId } = req.body;
console.log(req.body);
      try {
        const role = await prisma.roles.findFirst({
          where: { id: parseInt(roleId, 10) },
        });

        if (!role) {
          throw new HttpException(400, 'Invalid role');
        }

        const existingUser = await prisma.users.findMany({
          where: {
            OR: [
              { email: email },
              { phone: phone },
            ],
          },
        });
      
        if (existingUser.length > 0) {
          const conflictField = existingUser[0].email === email ? 'email' : 'phone';
          throw new HttpException(409, `${conflictField} already exists`);
        }

        const saltRounds = 10;
        const hashedPassword = await bcrypt.hash(password, saltRounds);

        const user = await prisma.users.create({
          data: {
            name,
            email,
            phone,
            address,
            password: hashedPassword,
            image: req.file ? req.file.path : null,
            roles:{
              connect:{
                id: parseInt(roleId, 10)
              }
            }
          },
        });

        delete user.password;
        
        res.status(201).json({ message: `User registered successfully`, result: user });
      } catch (error) {
        next(error);
      }
    },
  ];

  async login(req, res, next) {
    const { email, password } = req.body;
    try {
      const user = await prisma.users.findUnique({ where: { email }, include:{roles: true}});

      if (!user) {
        return next(new HttpException(401, 'Invalid email or password'));
      }

      const isPasswordValid = await bcrypt.compare(password, user.password);

      if (!isPasswordValid) {
        return next(new HttpException(401, 'Invalid email or password'));
      }

      const token = jwt.sign({ userId: user.id }, JWT_SECRET);
      const dataToSend = {
        name: user.name,
        email: user.email,
        phone: user.phone,
        role: user.roles.title,
        token
      }
      res.json({ message: 'Login successful', dataToSend });
    } catch (error) {
      console.error('Login Error:', error);
      next(new HttpException(400, error.message));
    }
  }

}

export default new AuthController();
