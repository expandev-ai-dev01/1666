import sql, { IRecordSet, ConnectionPool } from 'mssql';
import { config } from '@/config';

/**
 * @summary
 * Singleton class to manage the SQL Server connection pool.
 */
class DatabaseConnection {
  private static instance: DatabaseConnection;
  private pool: ConnectionPool;

  private constructor() {
    const dbConfig = {
      server: config.database.server,
      port: config.database.port,
      user: config.database.user,
      password: config.database.password,
      database: config.database.database,
      options: {
        ...config.database.options,
      },
    };
    this.pool = new sql.ConnectionPool(dbConfig);
  }

  public static getInstance(): DatabaseConnection {
    if (!DatabaseConnection.instance) {
      DatabaseConnection.instance = new DatabaseConnection();
    }
    return DatabaseConnection.instance;
  }

  public async getPool(): Promise<ConnectionPool> {
    if (!this.pool.connected && !this.pool.connecting) {
      await this.pool.connect();
    }
    return this.pool;
  }
}

/**
 * @summary
 * Executes a stored procedure with the given parameters.
 * @param procedureName The name of the stored procedure (e.g., '[schema].[spName]').
 * @param params An object containing the parameters for the stored procedure.
 * @returns The result from the database operation.
 */
export async function dbRequest(
  procedureName: string,
  params: Record<string, any>
): Promise<IRecordSet<any>[]> {
  try {
    const pool = await DatabaseConnection.getInstance().getPool();
    const request = pool.request();

    for (const key in params) {
      if (Object.prototype.hasOwnProperty.call(params, key)) {
        // Note: mssql library infers SQL type from JS type. For explicit control, you might need more logic here.
        request.input(key, params[key]);
      }
    }

    const result = await request.execute(procedureName);
    return result.recordsets;
  } catch (error) {
    console.error(`Database error executing ${procedureName}:`, error);
    // Re-throw the error to be handled by the service layer's try-catch block
    throw error;
  }
}
