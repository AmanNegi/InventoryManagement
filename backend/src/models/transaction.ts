import mongoose from 'mongoose';
import Joi from 'joi';

const transactionItem = new mongoose.Schema({
  itemTitle: {
    type: String,
    required: true,
  },
  itemId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'InventoryItem',
  },
  price: {
    type: Number,
    required: true,
    min: 0,
  },
  quantity: {
    type: Number,
    required: true,
    min: 0,
  },
});

const transactionSchema = new mongoose.Schema({
  totalAmount: {
    type: Number,
    required: true,
    min: 0,
  },
  datedAt: {
    type: Date,
    default: () => {
      return new Date();
    },
  },
  buyerName: {
    type: String,
    required: true,
  },
  biller: {
    type: String,
    required: true,
  },
  items: {
    type: [transactionItem],
    required: true,
  },
  paymentMethod: {
    type: String,
    enum: ['cash', 'online', 'takeaway'],
    default: 'cash',
  },
  discountAmount: {
    type: Number,
    default: 0,
  },
});

export const Transaction = mongoose.model('Transaction', transactionSchema);

export function validateTransaction(transaction: any) {
  const schema = Joi.object().keys({
    totalAmount: Joi.number().required(),
    buyerName: Joi.string().required(),
    biller: Joi.string().required(),
    items: Joi.array().items(
      Joi.object().keys({
        itemTitle: Joi.string().required(),
        itemId: Joi.string().required(),
        price: Joi.number().required(),
        quantity: Joi.number().required(),
      }),
    ),
    paymentMethod: Joi.string().valid('cash', 'online', 'takeaway'),
    discountAmount: Joi.number().default(0),
  });
  return schema.validate(transaction);
}
