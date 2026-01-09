import dataPreferences from '@ohos.data.preferences';
import { BusinessError } from '@ohos.base';
import common from '@ohos.app.ability.common';

/**
 * Preference Manager for app settings
 * Replaces Android Hawk library
 */
export class PreferenceManager {
  private static instance: PreferenceManager;
  private preferences: dataPreferences.Preferences | null = null;
  private readonly PREF_NAME = 'hbox_preferences';

  // Preference keys
  static readonly KEY_API_URL = 'api_url';
  static readonly KEY_HOME_REC = 'home_rec';
  static readonly KEY_HOME_NUM = 'home_num';
  static readonly KEY_PLAY_TYPE = 'play_type';
  static readonly KEY_IJK_CODEC = 'ijk_codec';
  static readonly KEY_SEARCH_VIEW = 'search_view';
  static readonly KEY_FAST_SEARCH_MODE = 'fast_search_mode';
  static readonly KEY_PLAY_SCALE = 'play_scale';
  static readonly KEY_LIVE_CROSS_TIME = 'live_cross_time';
  static readonly KEY_DEFAULT_PARSE = 'default_parse';
  static readonly KEY_API_CONFIG = 'api_config';

  private constructor() {
  }

  static getInstance(): PreferenceManager {
    if (!PreferenceManager.instance) {
      PreferenceManager.instance = new PreferenceManager();
    }
    return PreferenceManager.instance;
  }

  /**
   * Initialize preferences
   */
  async init(context: common.Context): Promise<void> {
    try {
      this.preferences = await dataPreferences.getPreferences(context, this.PREF_NAME);
      console.info('Preferences initialized successfully');
    } catch (err) {
      console.error(`Failed to init preferences: ${JSON.stringify(err)}`);
      throw err;
    }
  }

  /**
   * Put string value
   */
  async putString(key: string, value: string): Promise<void> {
    if (!this.preferences) return;

    try {
      await this.preferences.put(key, value);
      await this.preferences.flush();
    } catch (err) {
      console.error(`Failed to put string: ${JSON.stringify(err)}`);
    }
  }

  /**
   * Get string value
   */
  async getString(key: string, defaultValue: string = ''): Promise<string> {
    if (!this.preferences) return defaultValue;

    try {
      const value = await this.preferences.get(key, defaultValue);
      return value as string;
    } catch (err) {
      console.error(`Failed to get string: ${JSON.stringify(err)}`);
      return defaultValue;
    }
  }

  /**
   * Put number value
   */
  async putNumber(key: string, value: number): Promise<void> {
    if (!this.preferences) return;

    try {
      await this.preferences.put(key, value);
      await this.preferences.flush();
    } catch (err) {
      console.error(`Failed to put number: ${JSON.stringify(err)}`);
    }
  }

  /**
   * Get number value
   */
  async getNumber(key: string, defaultValue: number = 0): Promise<number> {
    if (!this.preferences) return defaultValue;

    try {
      const value = await this.preferences.get(key, defaultValue);
      return value as number;
    } catch (err) {
      console.error(`Failed to get number: ${JSON.stringify(err)}`);
      return defaultValue;
    }
  }

  /**
   * Put boolean value
   */
  async putBoolean(key: string, value: boolean): Promise<void> {
    if (!this.preferences) return;

    try {
      await this.preferences.put(key, value);
      await this.preferences.flush();
    } catch (err) {
      console.error(`Failed to put boolean: ${JSON.stringify(err)}`);
    }
  }

  /**
   * Get boolean value
   */
  async getBoolean(key: string, defaultValue: boolean = false): Promise<boolean> {
    if (!this.preferences) return defaultValue;

    try {
      const value = await this.preferences.get(key, defaultValue);
      return value as boolean;
    } catch (err) {
      console.error(`Failed to get boolean: ${JSON.stringify(err)}`);
      return defaultValue;
    }
  }

  /**
   * Put object (serialized as JSON)
   */
  async putObject(key: string, value: Object): Promise<void> {
    if (!this.preferences) return;

    try {
      const jsonStr = JSON.stringify(value);
      await this.preferences.put(key, jsonStr);
      await this.preferences.flush();
    } catch (err) {
      console.error(`Failed to put object: ${JSON.stringify(err)}`);
    }
  }

  /**
   * Get object (deserialized from JSON)
   */
  async getObject<T>(key: string, defaultValue: T | null = null): Promise<T | null> {
    if (!this.preferences) return defaultValue;

    try {
      const jsonStr = await this.preferences.get(key, '');
      if (jsonStr === '') return defaultValue;

      return JSON.parse(jsonStr as string) as T;
    } catch (err) {
      console.error(`Failed to get object: ${JSON.stringify(err)}`);
      return defaultValue;
    }
  }

  /**
   * Remove key
   */
  async remove(key: string): Promise<void> {
    if (!this.preferences) return;

    try {
      await this.preferences.delete(key);
      await this.preferences.flush();
    } catch (err) {
      console.error(`Failed to remove key: ${JSON.stringify(err)}`);
    }
  }

  /**
   * Clear all preferences
   */
  async clear(): Promise<void> {
    if (!this.preferences) return;

    try {
      await this.preferences.clear();
      await this.preferences.flush();
    } catch (err) {
      console.error(`Failed to clear preferences: ${JSON.stringify(err)}`);
    }
  }

  /**
   * Check if key exists
   */
  async has(key: string): Promise<boolean> {
    if (!this.preferences) return false;

    try {
      return await this.preferences.has(key);
    } catch (err) {
      console.error(`Failed to check key existence: ${JSON.stringify(err)}`);
      return false;
    }
  }
}
