import relationalStore from '@ohos.data.relationalStore';
import { BusinessError } from '@ohos.base';
import common from '@ohos.app.ability.common';

/**
 * Database Manager for HBox
 * Replaces Android Room database
 */
export class DatabaseManager {
  private static instance: DatabaseManager;
  private store: relationalStore.RdbStore | null = null;
  private readonly DB_NAME = 'hbox.db';
  private readonly DB_VERSION = 1;

  private constructor() {
  }

  static getInstance(): DatabaseManager {
    if (!DatabaseManager.instance) {
      DatabaseManager.instance = new DatabaseManager();
    }
    return DatabaseManager.instance;
  }

  /**
   * Initialize database
   */
  async init(context: common.Context): Promise<void> {
    const config: relationalStore.StoreConfig = {
      name: this.DB_NAME,
      securityLevel: relationalStore.SecurityLevel.S1
    };

    try {
      this.store = await relationalStore.getRdbStore(context, config);
      await this.createTables();
    } catch (err) {
      console.error(`Failed to init database: ${JSON.stringify(err)}`);
      throw err;
    }
  }

  /**
   * Create database tables
   */
  private async createTables(): Promise<void> {
    if (!this.store) return;

    // Create Cache table
    const createCacheTable = `
      CREATE TABLE IF NOT EXISTS Cache (
        key TEXT PRIMARY KEY,
        value BLOB
      )
    `;

    // Create VodRecord (watch history) table
    const createVodRecordTable = `
      CREATE TABLE IF NOT EXISTS VodRecord (
        vodId TEXT PRIMARY KEY,
        sourceKey TEXT,
        updateTime INTEGER,
        dataJson TEXT
      )
    `;

    // Create VodCollect (favorites) table
    const createVodCollectTable = `
      CREATE TABLE IF NOT EXISTS VodCollect (
        vodId TEXT PRIMARY KEY,
        sourceKey TEXT,
        name TEXT,
        pic TEXT,
        updateTime INTEGER
      )
    `;

    try {
      await this.store.executeSql(createCacheTable);
      await this.store.executeSql(createVodRecordTable);
      await this.store.executeSql(createVodCollectTable);
      console.info('Database tables created successfully');
    } catch (err) {
      console.error(`Failed to create tables: ${JSON.stringify(err)}`);
      throw err;
    }
  }

  /**
   * Get RdbStore instance
   */
  getStore(): relationalStore.RdbStore | null {
    return this.store;
  }

  /**
   * Insert or update cache
   */
  async saveCache(key: string, value: string): Promise<void> {
    if (!this.store) return;

    const valueBucket: relationalStore.ValuesBucket = {
      'key': key,
      'value': value
    };

    try {
      await this.store.insert('Cache', valueBucket, relationalStore.ConflictResolution.ON_CONFLICT_REPLACE);
    } catch (err) {
      console.error(`Failed to save cache: ${JSON.stringify(err)}`);
    }
  }

  /**
   * Get cache value
   */
  async getCache(key: string): Promise<string | null> {
    if (!this.store) return null;

    const predicates = new relationalStore.RdbPredicates('Cache');
    predicates.equalTo('key', key);

    try {
      const resultSet = await this.store.query(predicates, ['value']);
      if (resultSet.goToFirstRow()) {
        const value = resultSet.getString(resultSet.getColumnIndex('value'));
        resultSet.close();
        return value;
      }
      resultSet.close();
      return null;
    } catch (err) {
      console.error(`Failed to get cache: ${JSON.stringify(err)}`);
      return null;
    }
  }

  /**
   * Delete cache
   */
  async deleteCache(key: string): Promise<void> {
    if (!this.store) return;

    const predicates = new relationalStore.RdbPredicates('Cache');
    predicates.equalTo('key', key);

    try {
      await this.store.delete(predicates);
    } catch (err) {
      console.error(`Failed to delete cache: ${JSON.stringify(err)}`);
    }
  }

  /**
   * Save watch history
   */
  async saveVodRecord(vodId: string, sourceKey: string, dataJson: string): Promise<void> {
    if (!this.store) return;

    const valueBucket: relationalStore.ValuesBucket = {
      'vodId': vodId,
      'sourceKey': sourceKey,
      'updateTime': Date.now(),
      'dataJson': dataJson
    };

    try {
      await this.store.insert('VodRecord', valueBucket, relationalStore.ConflictResolution.ON_CONFLICT_REPLACE);
    } catch (err) {
      console.error(`Failed to save vod record: ${JSON.stringify(err)}`);
    }
  }

  /**
   * Get watch history list
   */
  async getVodRecordList(): Promise<VodRecord[]> {
    if (!this.store) return [];

    const predicates = new relationalStore.RdbPredicates('VodRecord');
    predicates.orderByDesc('updateTime');

    try {
      const resultSet = await this.store.query(predicates);
      const records: VodRecord[] = [];

      while (resultSet.goToNextRow()) {
        const record: VodRecord = {
          vodId: resultSet.getString(resultSet.getColumnIndex('vodId')),
          sourceKey: resultSet.getString(resultSet.getColumnIndex('sourceKey')),
          updateTime: resultSet.getLong(resultSet.getColumnIndex('updateTime')),
          dataJson: resultSet.getString(resultSet.getColumnIndex('dataJson'))
        };
        records.push(record);
      }

      resultSet.close();
      return records;
    } catch (err) {
      console.error(`Failed to get vod records: ${JSON.stringify(err)}`);
      return [];
    }
  }

  /**
   * Delete watch history
   */
  async deleteVodRecord(vodId: string): Promise<void> {
    if (!this.store) return;

    const predicates = new relationalStore.RdbPredicates('VodRecord');
    predicates.equalTo('vodId', vodId);

    try {
      await this.store.delete(predicates);
    } catch (err) {
      console.error(`Failed to delete vod record: ${JSON.stringify(err)}`);
    }
  }

  /**
   * Save favorite/collect
   */
  async saveVodCollect(vodId: string, sourceKey: string, name: string, pic: string): Promise<void> {
    if (!this.store) return;

    const valueBucket: relationalStore.ValuesBucket = {
      'vodId': vodId,
      'sourceKey': sourceKey,
      'name': name,
      'pic': pic,
      'updateTime': Date.now()
    };

    try {
      await this.store.insert('VodCollect', valueBucket, relationalStore.ConflictResolution.ON_CONFLICT_REPLACE);
    } catch (err) {
      console.error(`Failed to save vod collect: ${JSON.stringify(err)}`);
    }
  }

  /**
   * Get favorites list
   */
  async getVodCollectList(): Promise<VodCollect[]> {
    if (!this.store) return [];

    const predicates = new relationalStore.RdbPredicates('VodCollect');
    predicates.orderByDesc('updateTime');

    try {
      const resultSet = await this.store.query(predicates);
      const collects: VodCollect[] = [];

      while (resultSet.goToNextRow()) {
        const collect: VodCollect = {
          vodId: resultSet.getString(resultSet.getColumnIndex('vodId')),
          sourceKey: resultSet.getString(resultSet.getColumnIndex('sourceKey')),
          name: resultSet.getString(resultSet.getColumnIndex('name')),
          pic: resultSet.getString(resultSet.getColumnIndex('pic')),
          updateTime: resultSet.getLong(resultSet.getColumnIndex('updateTime'))
        };
        collects.push(collect);
      }

      resultSet.close();
      return collects;
    } catch (err) {
      console.error(`Failed to get vod collects: ${JSON.stringify(err)}`);
      return [];
    }
  }

  /**
   * Delete favorite
   */
  async deleteVodCollect(vodId: string): Promise<void> {
    if (!this.store) return;

    const predicates = new relationalStore.RdbPredicates('VodCollect');
    predicates.equalTo('vodId', vodId);

    try {
      await this.store.delete(predicates);
    } catch (err) {
      console.error(`Failed to delete vod collect: ${JSON.stringify(err)}`);
    }
  }

  /**
   * Check if video is collected
   */
  async isCollected(vodId: string): Promise<boolean> {
    if (!this.store) return false;

    const predicates = new relationalStore.RdbPredicates('VodCollect');
    predicates.equalTo('vodId', vodId);

    try {
      const resultSet = await this.store.query(predicates);
      const exists = resultSet.rowCount > 0;
      resultSet.close();
      return exists;
    } catch (err) {
      console.error(`Failed to check if collected: ${JSON.stringify(err)}`);
      return false;
    }
  }
}

/**
 * VodRecord interface
 */
export interface VodRecord {
  vodId: string;
  sourceKey: string;
  updateTime: number;
  dataJson: string;
}

/**
 * VodCollect interface
 */
export interface VodCollect {
  vodId: string;
  sourceKey: string;
  name: string;
  pic: string;
  updateTime: number;
}
