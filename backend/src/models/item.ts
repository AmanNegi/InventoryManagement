import mongoose from 'mongoose';
import Joi from 'joi';

const inventoryItemSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  description: {
    type: String,
    required: true,
  },
  images: {
    type: [String],
    required: true,
  },
  price: {
    type: Number,
    required: true,
    min: 0,
  },
  quantity: {
    type: Number,
    default: 1,
  },
  listedAt: {
    type: Date,
    default: () => {
      return new Date();
    },
  },
});

export const InventoryItem = mongoose.model(
  'InventoryItem',
  inventoryItemSchema,
);

export function validateInventoryItem(item: any) {
  const schema = Joi.object().keys({
    name: Joi.string().required(),
    description: Joi.string().required(),
    images: Joi.array().items(Joi.string()).required(),
    quantity: Joi.number().min(1).required(),
    price: Joi.number().required(),
  });
  return schema.validate(item);
}
