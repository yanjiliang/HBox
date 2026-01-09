/**
 * SourceBean - Video source configuration
 * Converted from Android SourceBean.java
 */
export class SourceBean {
  key: string = '';
  name: string = '';
  type: number = 0; // 0=XML, 1=JSON, 3=Spider
  api: string = '';
  searchable: number = 0;
  quickSearch: number = 0;
  filterable: number = 0;
  playerUrl: string = '';
  ext: string = '';
  categories: string[] = [];

  constructor(key?: string, name?: string, type?: number, api?: string) {
    if (key) this.key = key;
    if (name) this.name = name;
    if (type !== undefined) this.type = type;
    if (api) this.api = api;
  }

  isSearchable(): boolean {
    return this.searchable === 1;
  }

  isQuickSearch(): boolean {
    return this.quickSearch === 1;
  }

  isFilterable(): boolean {
    return this.filterable === 1;
  }
}

/**
 * ParseBean - Video parser configuration
 */
export class ParseBean {
  name: string = '';
  url: string = '';
  type: number = 0; // 0=Sniffer, 1=JSON, 2=JSON+ext, 3=Aggregate
  ext: string = '';
  isDefault: boolean = false;

  constructor(name?: string, url?: string) {
    if (name) this.name = name;
    if (url) this.url = url;
  }
}

/**
 * LiveChannelItem - Live TV channel
 */
export class LiveChannelItem {
  channelNum: number = 0;
  channelName: string = '';
  channelUrls: string[] = [];
  currentUrlIndex: number = 0;

  constructor(num: number, name: string, urls: string[]) {
    this.channelNum = num;
    this.channelName = name;
    this.channelUrls = urls;
  }

  getCurrentUrl(): string {
    if (this.channelUrls.length === 0) return '';
    return this.channelUrls[this.currentUrlIndex];
  }

  switchToNextUrl(): void {
    if (this.channelUrls.length > 1) {
      this.currentUrlIndex = (this.currentUrlIndex + 1) % this.channelUrls.length;
    }
  }
}

/**
 * LiveChannelGroup - Live channel group
 */
export class LiveChannelGroup {
  groupName: string = '';
  groupPassword: string = '';
  liveChannels: LiveChannelItem[] = [];

  constructor(name: string) {
    this.groupName = name;
  }

  isPasswordProtected(): boolean {
    return this.groupPassword !== '';
  }
}
