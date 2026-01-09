/**
 * Movie data model - converted from Android Movie.java
 * Represents video list with pagination
 */
export class Movie {
  page: number = 0;
  pagecount: number = 0; // Total pages
  pagesize: number = 0;
  recordcount: number = 0; // Total records
  videoList: Video[] = [];
}

/**
 * Video item model
 */
export class Video {
  last: string = ''; // Update time
  id: string = ''; // Content ID
  tid: number = 0; // Parent category ID
  name: string = ''; // Video name
  type: string = ''; // Type name
  pic: string = ''; // Thumbnail image URL
  lang: string = ''; // Language
  area: string = ''; // Region/Area
  year: number = 0; // Year
  state: string = ''; // State (更新中/完结)
  note: string = ''; // Description/episode info
  actor: string = ''; // Actors
  director: string = ''; // Director
  urlBean?: UrlBean; // Episode URLs
  des: string = ''; // Description
  sourceKey: string = ''; // Source identifier
}

/**
 * URL container for episodes
 */
export class UrlBean {
  infoList: UrlInfo[] = [];
}

/**
 * Episode URL info with flag (source type)
 */
export class UrlInfo {
  flag: string = ''; // Source flag (m3u8, MP4, etc.)
  urls: string = ''; // Concatenated episode URLs
  beanList: InfoBean[] = [];
}

/**
 * Individual episode info
 */
export class InfoBean {
  name: string = ''; // Episode name
  url: string = ''; // Episode URL

  constructor(name: string, url: string) {
    this.name = name;
    this.url = url;
  }
}
