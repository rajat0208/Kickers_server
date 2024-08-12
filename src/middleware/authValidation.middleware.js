import Joi from 'joi';
import HttpException from '../models/http-exception.model.js';

const schema = Joi.object({
  name: Joi.string().regex(/^[a-zA-Z\s]+$/).required().messages({
    'string.empty': 'Name is required',
    'string.pattern.base': 'Name must contain only letters and spaces',
  }),
  email: Joi.string().email().required().messages({
    'string.email': 'Valid email is required',
  }),
  phone: Joi.string().length(10).pattern(/^\d+$/).required().messages({
    'string.length': 'Phone number must be exactly 10 digits',
    'string.pattern.base': 'Phone number must contain only numbers',
  }),
  password: Joi.string().min(6).pattern(/^(?=.*[A-Za-z])(?=.*\d)/).required().messages({
    'string.min': 'Password must be at least 6 characters long',
    'string.pattern.base': 'Password must contain at least one letter and one number',
  }),
  address: Joi.string().messages({
    'string.empty': 'Address is required',
  }),
  roleId: Joi.required().messages({
    'any.only': 'Role Id cannot be empty',
  }),
});

const registerValidation = (req, res, next) => {
  const { error } = schema.validate(req.body, { abortEarly: false });
  if (error) {
    const errorsToShow = error.details.map(err => err.message);
    const errors = error.details.map(err => ({
      field: err.context.key,
      message: err.message,
    }));
    return next(new HttpException(400, errorsToShow));
  }
  next();
};

export { registerValidation };
