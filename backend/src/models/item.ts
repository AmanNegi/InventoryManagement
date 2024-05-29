import mongoose from 'mongoose';
import Joi from 'joi';

const inventoryItemSchema = new mongoose.Schema({
  title: {
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
  costPrice: {
    type: Number,
    required: true,
    min: 0,
  },
  sellingPrice: {
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
    title: Joi.string().required(),
    description: Joi.string().required(),
    images: Joi.array().items(Joi.string()).required(),
    quantity: Joi.number().min(1).required(),
    costPrice: Joi.number().required(),
    sellingPrice: Joi.number().required(),
  });
  return schema.validate(item);
}
