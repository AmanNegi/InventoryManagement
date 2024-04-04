import express from 'express';
import logger, { attachLogger } from './utils/logger';
import { connectToDB } from './utils/db';
import { registerRoutes } from './utils/routes';
import swaggerUi from 'swagger-ui-express';
import swaggerOutput from './swagger_output.json';
import env from 'dotenv';

const app = express();
app.use(express.json());
env.config();

if (process.env.NODE_ENV === 'dev') {
  app.use('/docs', swaggerUi.serve, swaggerUi.setup(swaggerOutput));
}

attachLogger(app);
registerRoutes(app);

const PORT = process.env.PORT || 3000;
app.listen(PORT, async () => {
  logger.info(`Listening on port http://localhost:${PORT}`);
  await connectToDB();
});
