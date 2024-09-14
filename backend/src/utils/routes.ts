import { Express } from 'express';
import { router as AuthRouter } from '../routes/auth';
import { router as ListRouter } from '../routes/list';
import { router as TransactionsRouter } from '../routes/transactions';

export function registerRoutes(app: Express) {
  app.use('/auth', AuthRouter);
  app.use('/list', ListRouter);
  app.use('/transactions', TransactionsRouter);
}
