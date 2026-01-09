import router from '@ohos.router';
import { DatabaseManager, VodRecord } from '../database/DatabaseManager';

/**
 * HistoryPage - Watch history page
 * Converted from Android HistoryActivity.java
 */
@Entry
@Component
struct HistoryPage {
  @State historyList: HistoryItem[] = [];
  @State isLoading: boolean = true;

  aboutToAppear() {
    this.loadHistory();
  }

  /**
   * Load watch history
   */
  private async loadHistory() {
    try {
      const records = await DatabaseManager.getInstance().getVodRecordList();
      this.historyList = records.map(record => {
        const data = JSON.parse(record.dataJson);
        return {
          vodId: record.vodId,
          sourceKey: record.sourceKey,
          name: data.name || '',
          pic: data.pic || '',
          playFlag: data.playFlag || '',
          playIndex: data.playIndex || 0,
          updateTime: record.updateTime
        };
      });
      this.isLoading = false;
    } catch (err) {
      console.error(`Failed to load history: ${JSON.stringify(err)}`);
      this.isLoading = false;
    }
  }

  /**
   * Navigate to detail page
   */
  private navigateToDetail(item: HistoryItem) {
    router.pushUrl({
      url: 'pages/DetailPage',
      params: {
        videoId: item.vodId,
        sourceKey: item.sourceKey
      }
    });
  }

  /**
   * Delete history item
   */
  private async deleteItem(vodId: string) {
    await DatabaseManager.getInstance().deleteVodRecord(vodId);
    this.loadHistory();
  }

  /**
   * Clear all history
   */
  private async clearAllHistory() {
    // TODO: Implement clear all functionality
    this.historyList = [];
  }

  /**
   * Navigate back
   */
  private goBack() {
    router.back();
  }

  /**
   * Format timestamp to readable date
   */
  private formatDate(timestamp: number): string {
    const date = new Date(timestamp);
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    return `${year}-${month}-${day} ${hours}:${minutes}`;
  }

  build() {
    Column() {
      // Top bar
      Row() {
        Image($r('app.media.icon_back'))
          .width(24)
          .height(24)
          .onClick(() => this.goBack())

        Text('观看历史')
          .fontSize(20)
          .fontColor(Color.White)
          .margin({ left: 20 })

        Blank()

        if (this.historyList.length > 0) {
          Text('清空')
            .fontSize(16)
            .fontColor('#BBFFFFFF')
            .onClick(() => this.clearAllHistory())
        }
      }
      .width('100%')
      .height(60)
      .padding({ left: 40, right: 40 })
      .backgroundColor('#1E1E1E')

      if (this.isLoading) {
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
      } else if (this.historyList.length === 0) {
        Column() {
          Text('暂无观看历史')
            .fontSize(16)
            .fontColor('#666666')
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .backgroundColor('#000000')
      } else {
        List({ space: 20 }) {
          ForEach(this.historyList, (item: HistoryItem) => {
            ListItem() {
              Row() {
                Image(item.pic)
                  .width(120)
                  .height(160)
                  .borderRadius(8)
                  .objectFit(ImageFit.Cover)

                Column({ space: 10 }) {
                  Text(item.name)
                    .fontSize(18)
                    .fontColor(Color.White)
                    .fontWeight(FontWeight.Bold)
                    .maxLines(2)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })

                  Text(`播放至: ${item.playFlag} 第${item.playIndex + 1}集`)
                    .fontSize(14)
                    .fontColor('#BBFFFFFF')

                  Text(this.formatDate(item.updateTime))
                    .fontSize(14)
                    .fontColor('#888888')

                  Blank()

                  Row({ space: 15 }) {
                    Button('继续播放')
                      .fontSize(14)
                      .fontColor(Color.White)
                      .backgroundColor('#FF5722')
                      .padding({ left: 20, right: 20, top: 8, bottom: 8 })
                      .borderRadius(6)

                    Button('删除')
                      .fontSize(14)
                      .fontColor(Color.White)
                      .backgroundColor('#666666')
                      .padding({ left: 20, right: 20, top: 8, bottom: 8 })
                      .borderRadius(6)
                      .onClick(() => this.deleteItem(item.vodId))
                  }
                }
                .layoutWeight(1)
                .height(160)
                .margin({ left: 20 })
                .alignItems(HorizontalAlign.Start)
              }
              .width('100%')
              .padding(20)
              .borderRadius(8)
              .backgroundColor('#1E1E1E')
            }
            .onClick(() => this.navigateToDetail(item))
          }, (item: HistoryItem) => item.vodId)
        }
        .layoutWeight(1)
        .padding(30)
        .backgroundColor('#000000')
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#000000')
  }
}

/**
 * History item interface
 */
interface HistoryItem {
  vodId: string;
  sourceKey: string;
  name: string;
  pic: string;
  playFlag: string;
  playIndex: number;
  updateTime: number;
}
