import mongoose from 'mongoose';
import Joi from 'joi';

const userSchema = new mongoose.Schema({
  email: {
    type: String,
    unique: true,
    required: true,
  },
  phone: {
    type: String,
    required: true,
    min: 10,
  },
  name: {
    type: String,
    required: true,
    min: 5,
    max: 50,
  },
  password: {
    type: String,
    required: true,
    min: 5,
    max: 1024,
  },
  userType: {
    type: String,
    enum: ['admin', 'customer'],
    default: 'customer',
  },
  createdAt: {
    type: Date,
    default: () => {
      return new Date();
    },
  },
});

export const User = mongoose.model('User', userSchema);

export function validateUser(user: any) {
  const schema = Joi.object().keys({
    name: Joi.string().required(),
    email: Joi.string().required().email(),
    password: Joi.string().required(),
    phone: Joi.string().required(),
  });
  return schema.validate(user);
}

export function validateLogin(req: any) {
  const schema = Joi.object().keys({
    email: Joi.string().required().email(),
    password: Joi.string().required(),
  });
  return schema.validate(req);
}

export function validateSignUp(req: any) {
  const schema = Joi.object().keys({
    name: Joi.string().required(),
    email: Joi.string().required().email(),
    password: Joi.string().required(),
    phone: Joi.string().required(),
  });
  return schema.validate(req);
}
