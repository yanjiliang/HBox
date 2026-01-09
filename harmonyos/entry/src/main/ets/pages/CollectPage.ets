import router from '@ohos.router';
import { DatabaseManager, VodCollect } from '../database/DatabaseManager';

/**
 * CollectPage - Favorites/Collection page
 * Converted from Android CollectActivity.java
 */
@Entry
@Component
struct CollectPage {
  @State collectList: VodCollect[] = [];
  @State isLoading: boolean = true;

  aboutToAppear() {
    this.loadCollections();
  }

  /**
   * Load collections
   */
  private async loadCollections() {
    try {
      this.collectList = await DatabaseManager.getInstance().getVodCollectList();
      this.isLoading = false;
    } catch (err) {
      console.error(`Failed to load collections: ${JSON.stringify(err)}`);
      this.isLoading = false;
    }
  }

  /**
   * Navigate to detail page
   */
  private navigateToDetail(item: VodCollect) {
    router.pushUrl({
      url: 'pages/DetailPage',
      params: {
        videoId: item.vodId,
        sourceKey: item.sourceKey
      }
    });
  }

  /**
   * Delete collection item
   */
  private async deleteItem(vodId: string) {
    await DatabaseManager.getInstance().deleteVodCollect(vodId);
    this.loadCollections();
  }

  /**
   * Navigate back
   */
  private goBack() {
    router.back();
  }

  build() {
    Column() {
      // Top bar
      Row() {
        Text('←')
          .fontSize(24)
          .fontColor(Color.White)
          .onClick(() => this.goBack())

        Text('我的收藏')
          .fontSize(20)
          .fontColor(Color.White)
          .margin({ left: 20 })
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
      } else if (this.collectList.length === 0) {
        Column() {
          Text('暂无收藏')
            .fontSize(16)
            .fontColor('#666666')
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .backgroundColor('#000000')
      } else {
        Grid() {
          ForEach(this.collectList, (item: VodCollect) => {
            GridItem() {
              Column() {
                Stack({ alignContent: Alignment.TopEnd }) {
                  Image(item.pic)
                    .width('100%')
                    .height(200)
                    .borderRadius(8)
                    .objectFit(ImageFit.Cover)

                  Text('✕')
                    .fontSize(24)
                    .fontColor(Color.White)
                    .margin({ top: 8, right: 8 })
                    .onClick(() => this.deleteItem(item.vodId))
                }

                Text(item.name)
                  .fontSize(16)
                  .fontColor(Color.White)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .margin({ top: 8 })
              }
              .width('100%')
              .padding(10)
            }
            .onClick(() => this.navigateToDetail(item))
          }, (item: VodCollect) => item.vodId)
        }
        .columnsTemplate('1fr 1fr 1fr 1fr 1fr')
        .rowsGap(20)
        .columnsGap(20)
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
