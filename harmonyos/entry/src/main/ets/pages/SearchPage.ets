import router from '@ohos.router';
import { Video } from '../model/Movie';

/**
 * SearchPage - Search page
 * Converted from Android SearchActivity.java
 */
@Entry
@Component
struct SearchPage {
  @State searchKeyword: string = '';
  @State searchResults: Video[] = [];
  @State searchHistory: string[] = [];
  @State isSearching: boolean = false;

  aboutToAppear() {
    this.loadSearchHistory();
  }

  /**
   * Load search history
   */
  private loadSearchHistory() {
    // TODO: Load from database or preferences
    this.searchHistory = [];
  }

  /**
   * Execute search
   */
  private async performSearch() {
    if (!this.searchKeyword.trim()) {
      return;
    }

    this.isSearching = true;

    try {
      // TODO: Implement API call to search
      // This will call the network API with search keyword

      // Save to search history
      if (!this.searchHistory.includes(this.searchKeyword)) {
        this.searchHistory.unshift(this.searchKeyword);
        if (this.searchHistory.length > 10) {
          this.searchHistory = this.searchHistory.slice(0, 10);
        }
      }
    } catch (err) {
      console.error(`Search failed: ${JSON.stringify(err)}`);
    } finally {
      this.isSearching = false;
    }
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
   * Clear search history
   */
  private clearHistory() {
    this.searchHistory = [];
  }

  /**
   * Navigate back
   */
  private goBack() {
    router.back();
  }

  build() {
    Column() {
      // Top bar with search input
      Row() {
        Text('←')
          .fontSize(24)
          .fontColor(Color.White)
          .onClick(() => this.goBack())

        TextInput({ placeholder: '搜索电影、电视剧、综艺...', text: this.searchKeyword })
          .layoutWeight(1)
          .height(40)
          .margin({ left: 20, right: 20 })
          .backgroundColor('#333333')
          .placeholderColor('#888888')
          .fontColor(Color.White)
          .onChange((value: string) => {
            this.searchKeyword = value;
          })
          .onSubmit(() => {
            this.performSearch();
          })

        Button('搜索')
          .fontSize(16)
          .fontColor(Color.White)
          .backgroundColor('#FF5722')
          .padding({ left: 20, right: 20 })
          .onClick(() => this.performSearch())
      }
      .width('100%')
      .height(60)
      .padding({ left: 30, right: 30 })
      .backgroundColor('#1E1E1E')

      if (this.isSearching) {
        Column() {
          LoadingProgress()
            .width(50)
            .height(50)
            .color(Color.White)
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .backgroundColor('#000000')
      } else if (this.searchResults.length > 0) {
        // Search results
        Scroll() {
          Grid() {
            ForEach(this.searchResults, (video: Video) => {
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
          .padding(30)
        }
        .layoutWeight(1)
        .scrollBar(BarState.Auto)
        .backgroundColor('#000000')
      } else {
        // Search history
        Column() {
          if (this.searchHistory.length > 0) {
            Row() {
              Text('搜索历史')
                .fontSize(18)
                .fontColor(Color.White)
                .fontWeight(FontWeight.Bold)

              Blank()

              Text('清空')
                .fontSize(14)
                .fontColor('#BBFFFFFF')
                .onClick(() => this.clearHistory())
            }
            .width('100%')
            .padding(30)

            Flex({ wrap: FlexWrap.Wrap }) {
              ForEach(this.searchHistory, (keyword: string) => {
                Text(keyword)
                  .fontSize(14)
                  .fontColor('#BBFFFFFF')
                  .padding({ left: 15, right: 15, top: 8, bottom: 8 })
                  .margin({ right: 10, bottom: 10 })
                  .borderRadius(20)
                  .backgroundColor('#333333')
                  .onClick(() => {
                    this.searchKeyword = keyword;
                    this.performSearch();
                  })
              })
            }
            .padding({ left: 30, right: 30 })
          } else {
            Column() {
              Text('暂无搜索历史')
                .fontSize(16)
                .fontColor('#666666')
            }
            .width('100%')
            .layoutWeight(1)
            .justifyContent(FlexAlign.Center)
          }
        }
        .width('100%')
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .backgroundColor('#000000')
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#000000')
  }
}
