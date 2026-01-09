import router from '@ohos.router';
import { Video } from '../model/Movie';
import { SourceBean } from '../model/SourceBean';
import { PreferenceManager } from '../common/PreferenceManager';

/**
 * HomePage - Main entry page for HBox TV
 * Converted from Android HomeActivity.java
 */
@Entry
@Component
struct HomePage {
  @State currentDate: string = '';
  @State currentTime: string = '';
  @State sourceName: string = 'HBox';
  @State categories: CategoryItem[] = [];
  @State currentCategory: number = 0;
  @State videoList: Video[] = [];
  @State isLoading: boolean = true;

  private dateTimer: number = -1;

  aboutToAppear() {
    this.startDateTimeUpdate();
    this.loadConfig();
  }

  aboutToDisappear() {
    if (this.dateTimer !== -1) {
      clearInterval(this.dateTimer);
    }
  }

  /**
   * Start date/time update timer
   */
  private startDateTimeUpdate() {
    this.updateDateTime();
    this.dateTimer = setInterval(() => {
      this.updateDateTime();
    }, 1000);
  }

  /**
   * Update current date and time
   */
  private updateDateTime() {
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');

    this.currentDate = `${year}/${month}/${day}`;
    this.currentTime = `${hours}:${minutes}`;
  }

  /**
   * Load configuration from preferences
   */
  private async loadConfig() {
    try {
      const apiUrl = await PreferenceManager.getInstance().getString(PreferenceManager.KEY_API_URL);
      if (apiUrl) {
        // Load API config and categories
        this.loadCategories();
      } else {
        // Show config dialog
        this.showConfigDialog();
      }
    } catch (err) {
      console.error(`Failed to load config: ${JSON.stringify(err)}`);
    }
  }

  /**
   * Load categories
   */
  private loadCategories() {
    // TODO: Implement API call to load categories
    // This will be connected to the SourceViewModel logic
    this.categories = [
      { id: '1', name: '电影' },
      { id: '2', name: '电视剧' },
      { id: '3', name: '综艺' },
      { id: '4', name: '动漫' },
      { id: '5', name: '纪录片' }
    ];
    this.isLoading = false;
  }

  /**
   * Show config dialog
   */
  private showConfigDialog() {
    // Navigate to settings page
    router.pushUrl({
      url: 'pages/SettingPage'
    });
  }

  /**
   * Handle category selection
   */
  private onCategorySelected(index: number) {
    this.currentCategory = index;
    this.loadVideoList();
  }

  /**
   * Load video list for selected category
   */
  private loadVideoList() {
    // TODO: Implement API call to load video list
    this.videoList = [];
  }

  /**
   * Navigate to detail page
   */
  private navigateToDetail(video: Video) {
    router.pushUrl({
      url: 'pages/DetailPage',
      params: {
        videoId: video.id,
        sourceKey: video.sourceKey
      }
    });
  }

  /**
   * Navigate to search page
   */
  private navigateToSearch() {
    router.pushUrl({
      url: 'pages/SearchPage'
    });
  }

  /**
   * Navigate to settings
   */
  private navigateToSettings() {
    router.pushUrl({
      url: 'pages/SettingPage'
    });
  }

  /**
   * Navigate to history
   */
  private navigateToHistory() {
    router.pushUrl({
      url: 'pages/HistoryPage'
    });
  }

  /**
   * Navigate to favorites
   */
  private navigateToFavorites() {
    router.pushUrl({
      url: 'pages/CollectPage'
    });
  }

  build() {
    Column() {
      // Top bar
      Row() {
        // Left side - menu items
        Row({ space: 30 }) {
          Text('首页')
            .fontSize(20)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)

          Text('搜索')
            .fontSize(18)
            .fontColor('#BBFFFFFF')
            .onClick(() => this.navigateToSearch())

          Text('历史')
            .fontSize(18)
            .fontColor('#BBFFFFFF')
            .onClick(() => this.navigateToHistory())

          Text('收藏')
            .fontSize(18)
            .fontColor('#BBFFFFFF')
            .onClick(() => this.navigateToFavorites())

          Text('设置')
            .fontSize(18)
            .fontColor('#BBFFFFFF')
            .onClick(() => this.navigateToSettings())
        }
        .layoutWeight(1)

        // Right side - date/time and source name
        Row({ space: 20 }) {
          Text(this.sourceName)
            .fontSize(16)
            .fontColor('#BBFFFFFF')

          Text(`${this.currentDate} ${this.currentTime}`)
            .fontSize(16)
            .fontColor('#BBFFFFFF')
        }
      }
      .width('100%')
      .height(60)
      .padding({ left: 40, right: 40 })
      .backgroundColor('#1E1E1E')

      // Content area
      Row() {
        // Left sidebar - categories
        List({ space: 10 }) {
          ForEach(this.categories, (category: CategoryItem, index: number) => {
            ListItem() {
              Text(category.name)
                .fontSize(18)
                .fontColor(this.currentCategory === index ? Color.White : '#BBFFFFFF')
                .fontWeight(this.currentCategory === index ? FontWeight.Bold : FontWeight.Normal)
                .padding({ left: 20, right: 20, top: 10, bottom: 10 })
                .borderRadius(8)
                .backgroundColor(this.currentCategory === index ? '#FF5722' : 'transparent')
            }
            .onClick(() => this.onCategorySelected(index))
          }, (category: CategoryItem) => category.id)
        }
        .width(150)
        .height('100%')
        .backgroundColor('#1E1E1E')
        .padding({ top: 20, left: 10, right: 10 })

        // Right content - video grid
        if (this.isLoading) {
          Column() {
            LoadingProgress()
              .width(50)
              .height(50)
              .color(Color.White)
          }
          .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .backgroundColor('#000000')
        } else {
          Grid() {
            ForEach(this.videoList, (video: Video) => {
              GridItem() {
                Column() {
                  Image(video.pic)
                    .width('100%')
                    .height(200)
                    .borderRadius(8)
                    .objectFit(ImageFit.Cover)

                  Text(video.name)
                    .fontSize(16)
                    .fontColor(Color.White)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .margin({ top: 8 })

                  if (video.note) {
                    Text(video.note)
                      .fontSize(14)
                      .fontColor('#BBFFFFFF')
                      .maxLines(1)
                      .margin({ top: 4 })
                  }
                }
                .width('100%')
                .padding(10)
              }
              .onClick(() => this.navigateToDetail(video))
            }, (video: Video) => video.id)
          }
          .columnsTemplate('1fr 1fr 1fr 1fr 1fr')
          .rowsGap(20)
          .columnsGap(20)
          .width('100%')
          .height('100%')
          .padding(20)
          .backgroundColor('#000000')
        }
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#000000')
  }
}

/**
 * Category item interface
 */
interface CategoryItem {
  id: string;
  name: string;
}
