import mongoose from 'mongoose';
import logger from '../utils/logger';

export async function connectToDB() {
  const dbUrl = process.env.DATABASE_URL ?? '';

  try {
    const res = await mongoose.connect(dbUrl);
    if (res) {
      logger.info('Connected to Database...');
      return res;
    }

    return undefined;
  } catch (err) {
    logger.error('Error connecting to Database...');
    return err;
  }
}
