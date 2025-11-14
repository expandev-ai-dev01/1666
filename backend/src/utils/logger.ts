/**
 * @summary
 * A simple logger utility. For production, consider replacing with a more robust logger like Winston or Pino.
 */

const log = (level: 'info' | 'warn' | 'error', message: string, data?: any) => {
  const timestamp = new Date().toISOString();
  const logObject = {
    timestamp,
    level,
    message,
    data,
  };
  console.log(JSON.stringify(logObject));
};

export const logger = {
  info: (message: string, data?: any) => log('info', message, data),
  warn: (message: string, data?: any) => log('warn', message, data),
  error: (message: string, data?: any) => log('error', message, data),
};
