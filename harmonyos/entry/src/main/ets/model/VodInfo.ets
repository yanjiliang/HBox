/**
 * VodInfo - Enhanced video information with episode management
 * Converted from Android VodInfo.java
 */
export class VodInfo {
  id: string = '';
  name: string = '';
  pic: string = '';
  type: string = '';
  year: string = '';
  area: string = '';
  lang: string = '';
  actor: string = '';
  director: string = '';
  des: string = '';
  note: string = '';

  seriesFlags: VodSeriesFlag[] = [];
  seriesMap: Map<string, VodSeries[]> = new Map();
  playFlag: string = '';
  playIndex: number = 0;
  reverseSort: boolean = false;
  sourceKey: string = '';
}

/**
 * Video series flag (source type: m3u8, MP4, etc.)
 */
export class VodSeriesFlag {
  name: string = '';
  episode: VodSeries[] = [];

  constructor(name: string) {
    this.name = name;
  }
}

/**
 * Video series episode
 */
export class VodSeries {
  site: string = '';
  sourceKey: string = '';
  name: string = '';
  url: string = '';
  index: number = 0;
  selected: boolean = false;

  constructor(sourceKey: string, name: string, url: string) {
    this.sourceKey = sourceKey;
    this.name = name;
    this.url = url;
  }
}
