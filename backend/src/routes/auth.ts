import { User, validateLogin, validateSignUp } from '../models/user';
import express from 'express';
import _ from 'lodash';
import mongoose from 'mongoose';

export const router = express.Router();

/**
 * Handles user login.
 * @param {Object} req - The request object.
 * @param {Object} req.body - The request body.
 * @param {string} req.body.email - The user's email.
 * @param {string} req.body.password - The user's password.
 */
router.post('/login', async (req, res) => {
  const { error } = validateLogin(req.body);
  if (error) return res.status(400).send(error.details[0].message);

  const user = await User.findOne({ email: req.body.email });
  if (!user) {
    return res.status(400).send('No User Exists with this email');
  }

  const validPassword = req.body.password === user.password;
  if (!validPassword) return res.status(400).send('Invalid Password');

  return res.send(_.omit(user.toObject(), ['password', '__v']));
});

/**
 * Handles user signup.
 * @param {Object} req - The request object.
 * @param {Object} req.body - The request body.
 * @param {string} req.body.email - The user's email.
 * @param {string} req.body.name - The user's name.
 * @param {string} req.body.password - The user's password.
 * @param {string} req.body.phone - The user's phone number.
 */
router.post('/signup', async (req, res) => {
  const { error } = validateSignUp(req.body);
  if (error) return res.status(400).send(error.details[0].message);

  let user = await User.findOne({ email: req.body.email });
  if (user) {
    return res.status(400).send('User with this email already exists');
  }

  let userType = 'customer';

  if (process.env.ADMIN_EMAIL === req.body.email) {
    userType = 'admin';
  }

  user = new User({ ...req.body, userType });

  await user.save();
  return res.send(_.omit(user.toObject(), ['password', '__v']));
});

/**
 * Get All Users (For Admin Panel)
 * @param {Object} req - The request object.
 * @param {string} req.body.adminId - The admin's ID.
 */
router.post('/getAll', async (req, res) => {
  // Validate if Id is valid
  if (!mongoose.Types.ObjectId.isValid(req.body.adminId)) {
    return res.status(404).send('Invalid Admin ID');
  }

  const user = await User.findOne({ _id: req.body.adminId });
  // Check if user exists
  if (!user) {
    return res.status(400).send('No User Exists with this email');
  }

  if (user.userType !== 'admin') {
    return res.status(404).send('You are not an Admin!');
  }

  // User is admin, fetch all users and return
  const users = await User.find(
    {},
    {
      password: 0,
      __v: 0,
    },
  );
  return res.send(users);
});

/**
 * Check if a user exists with the given email.
 * @param {Object} req - The request object.
 * @param {string} req.body.email - The user's email.
 */
router.post('/exists', async (req, res) => {
  const email = req.body.email;
  if (!email) return res.status(400).send('Enter a valid email');

  const user = await User.findOne({ email });
  if (!user) {
    return res.status(400).send('No User Exists with this email address');
  }
  return res.send(_.omit(user.toObject(), ['password', '__v']));
});

/**
 * Get a User by ID
 * @param {Object} req - The request object.
 * @param {string} req.params.id - The user's ID.
 */
router.get('/:id', async (req, res) => {
  const user = await User.findOne({ _id: req.params.id });
  if (!user) return res.status(400).send('User not found');

  return res.send(_.omit(user.toObject(), ['password', '__v']));
});
