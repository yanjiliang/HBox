import http from '@ohos.net.http';
import { BusinessError } from '@ohos.base';

/**
 * HTTP Client for network requests
 * Replaces Android OkHttp/OkGo implementation
 */
export class HttpClient {
  private static instance: HttpClient;

  private constructor() {
  }

  static getInstance(): HttpClient {
    if (!HttpClient.instance) {
      HttpClient.instance = new HttpClient();
    }
    return HttpClient.instance;
  }

  /**
   * Execute GET request
   */
  async get(url: string, headers?: Record<string, string>): Promise<string> {
    return this.request(url, http.RequestMethod.GET, null, headers);
  }

  /**
   * Execute POST request
   */
  async post(url: string, data?: string | Object, headers?: Record<string, string>): Promise<string> {
    return this.request(url, http.RequestMethod.POST, data, headers);
  }

  /**
   * Generic HTTP request method
   */
  private async request(
    url: string,
    method: http.RequestMethod,
    data?: string | Object,
    headers?: Record<string, string>
  ): Promise<string> {
    return new Promise((resolve, reject) => {
      const httpRequest = http.createHttp();

      const requestHeaders: Record<string, string> = {
        'Content-Type': 'application/json',
        'User-Agent': 'HBox/1.0.0 HarmonyOS',
        ...headers
      };

      const options: http.HttpRequestOptions = {
        method: method,
        header: requestHeaders,
        readTimeout: 30000,
        connectTimeout: 30000
      };

      if (data) {
        if (typeof data === 'string') {
          options.extraData = data;
        } else {
          options.extraData = JSON.stringify(data);
        }
      }

      httpRequest.request(url, options, (err: BusinessError, data: http.HttpResponse) => {
        if (!err) {
          if (data.responseCode === 200) {
            const result = data.result as string;
            resolve(result);
          } else {
            reject(new Error(`HTTP ${data.responseCode}: ${data.result}`));
          }
        } else {
          reject(err);
        }

        // Destroy the request
        httpRequest.destroy();
      });
    });
  }

  /**
   * Download file
   */
  async downloadFile(url: string, filePath: string): Promise<void> {
    return new Promise((resolve, reject) => {
      const httpRequest = http.createHttp();

      httpRequest.request(url, {
        method: http.RequestMethod.GET,
        expectDataType: http.HttpDataType.ARRAY_BUFFER
      }, (err: BusinessError, data: http.HttpResponse) => {
        if (!err) {
          if (data.responseCode === 200) {
            // File saving logic would go here
            resolve();
          } else {
            reject(new Error(`Download failed: ${data.responseCode}`));
          }
        } else {
          reject(err);
        }

        httpRequest.destroy();
      });
    });
  }
}
