import { InventoryItem, validateInventoryItem } from '../models/item';
import express from 'express';
import _ from 'lodash';
import mongoose from 'mongoose';

export const router = express.Router();

/**
 * Get all items.
 */
router.get('/getAll', async (req, res) => {
  const items = await InventoryItem.find({});

  return res.send(items);
});

/**
 * Add a Product
 * @param {Object} req - The request object.
 * @param {Object} req.body - The request body.
 * @param {string} req.body.title - The title of the item.
 * @param {string} req.body.description - The description of the item.
 * @param {number} req.body.price - The price of the item.
 * @param {number} req.body.quantity - The quantity of the item.
 * @param {Array<string>} req.body.image - The array with image URL of the item.
 */
router.post('/addItem', async (req, res) => {
  const { error } = validateInventoryItem(req.body);
  if (error) return res.status(400).send(error.details[0].message);

  const item = new InventoryItem(req.body);
  await item.save();

  return res.send(item);
});

/**
 * Get a Item by ID
 * @param {Object} req - The request object.
 * @param {string} req.params.id - The ID of the item.
 */
router.get('/getItem/:id', async (req, res) => {
  if (!mongoose.Types.ObjectId.isValid(req.params.id)) {
    return res.status(404).send('Invalid Item ID');
  }
  const item = await InventoryItem.findOne({ _id: req.params.id });
  if (!item) {
    return res.status(404).send('No Product Found');
  }
  return res.send(item);
});

/**
 * Update a Item by ID
 * @param {Object} req - The request object.
 * @param {string} req.params.id - The ID of the item.
 */
router.put('/updateItem/:id', async (req, res) => {
  if (!mongoose.Types.ObjectId.isValid(req.params.id)) {
    return res.status(404).send('Invalid Item ID');
  }

  const item = await InventoryItem.findOneAndUpdate(
    { _id: req.params.id },
    req.body,
    { new: true },
  );
  if (!item) {
    return res.status(404).send('No Product Found');
  }
  return res.send(item);
});
