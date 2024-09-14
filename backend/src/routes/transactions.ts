import { Transaction, validateTransaction } from '../models/transaction';
import express from 'express';
import _ from 'lodash';
import { InventoryItem } from '../models/item';

export const router = express.Router();

/**
 * Create a new transaction.
 */
router.post('/add', async (req, res) => {
  const { error } = validateTransaction(req.body);
  if (error) return res.status(400).send(error.details[0].message);

  // Check if the quantity of items is available
  const model = req.body as TransactionModel;
  let updatedItems = [];

  for (const item of model.items) {
    const e = await InventoryItem.findById(item.itemId);
    if (!e) return res.status(400).send('An item was not found');

    // if (item.quantity > e.quantity) {
    //   return res
    //     .status(400)
    //     .send(
    //       `"${item.itemTitle}" Quantity exceeds current capacity. (${item.quantity} of ${e.quantity})`,
    //     );
    // }

    //! allow negative as per requirements
    e.quantity -= item.quantity;
    updatedItems.push(e);
  }

  for (const item of updatedItems) {
    await item.save();
  }

  const transaction = new Transaction(req.body);
  await transaction.save();

  return res.send(transaction);
});

router.get('/all', async (req, res) => {
  const transactions = await Transaction.find().sort({ datedAt: -1 });
  return res.send(transactions);
});

router.get('/stats/last30Days', async (req, res) => {
  // count transactions for each day
  // const transactions = await Transaction.find();
  const oneWeekAgo = new Date();
  oneWeekAgo.setDate(oneWeekAgo.getDate() - 30);

  const transactions = await Transaction.find({
    datedAt: { $gte: oneWeekAgo },
  }).sort({ datedAt: -1 });

  const grouped = _.groupBy(transactions, (t) => {
    return new Date(t.datedAt).toDateString();
  });

  const stats = _.map(grouped, (v, k) => {
    let totalItemsSold = 0;
    let totalAmount = 0;

    for (const t of v) {
      totalItemsSold += t.items.length;
      totalAmount += t.totalAmount;
    }

    return { date: k, count: v.length, totalItemsSold, totalAmount };
  });

  return res.send(stats);
});

export type TransactionModel = {
  items: TransactionItem[];
  totalAmount: number;
  buyerName: string;
  biller: string;
  _id: string;
};

type TransactionItem = {
  itemTitle: string;
  itemId: string;
  quantity: number;
  price: number;
};
