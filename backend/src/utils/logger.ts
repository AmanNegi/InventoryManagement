import winston from 'winston';
import { Express } from 'express';
const devTransports = [
  new winston.transports.Console(),
  new winston.transports.File({ filename: 'combined.log' }),
];
const testTransports = [new winston.transports.File({ filename: 'test.log' })];

const logger = winston.createLogger({
  level: 'debug',
  format: winston.format.json(),
  transports: process.env.NODE_ENV === 'test' ? testTransports : devTransports,
});

export function attachLogger(app: Express) {
  app.use((req, res, next) => {
    logger.info(`${req.method} ${req.url}`);
    next();
  });
}

export default logger;
