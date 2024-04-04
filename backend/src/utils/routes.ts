import { Express } from 'express';
import { router as AuthRouter } from '../routes/auth';
import { router as ListRouter } from '../routes/list';

export function registerRoutes(app: Express) {
  app.use('/auth', AuthRouter);
  app.use('/list', ListRouter);
}
