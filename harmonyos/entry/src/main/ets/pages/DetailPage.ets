import router from '@ohos.router';
import { VodInfo, VodSeriesFlag, VodSeries } from '../model/VodInfo';
import { DatabaseManager } from '../database/DatabaseManager';

/**
 * DetailPage - Video detail page
 * Converted from Android DetailActivity.java
 */
@Entry
@Component
struct DetailPage {
  @State vodInfo: VodInfo = new VodInfo();
  @State currentFlag: number = 0;
  @State currentEpisode: number = 0;
  @State isCollected: boolean = false;
  @State isLoading: boolean = true;

  private videoId: string = '';
  private sourceKey: string = '';

  aboutToAppear() {
    const params = router.getParams() as DetailParams;
    if (params) {
      this.videoId = params.videoId;
      this.sourceKey = params.sourceKey;
      this.loadDetail();
      this.checkCollected();
    }
  }

  /**
   * Load video detail
   */
  private async loadDetail() {
    try {
      // TODO: Implement API call to load video detail
      // This will call the network API to get video details
      this.isLoading = false;
    } catch (err) {
      console.error(`Failed to load detail: ${JSON.stringify(err)}`);
      this.isLoading = false;
    }
  }

  /**
   * Check if video is collected
   */
  private async checkCollected() {
    const collected = await DatabaseManager.getInstance().isCollected(this.videoId);
    this.isCollected = collected;
  }

  /**
   * Toggle collection status
   */
  private async toggleCollect() {
    if (this.isCollected) {
      await DatabaseManager.getInstance().deleteVodCollect(this.videoId);
      this.isCollected = false;
    } else {
      await DatabaseManager.getInstance().saveVodCollect(
        this.videoId,
        this.sourceKey,
        this.vodInfo.name,
        this.vodInfo.pic
      );
      this.isCollected = true;
    }
  }

  /**
   * Select flag (source type)
   */
  private onFlagSelected(index: number) {
    this.currentFlag = index;
    this.currentEpisode = 0;
  }

  /**
   * Select episode and start playback
   */
  private onEpisodeSelected(index: number) {
    this.currentEpisode = index;
    this.startPlay();
  }

  /**
   * Start video playback
   */
  private startPlay() {
    if (this.vodInfo.seriesFlags.length === 0) return;

    const flag = this.vodInfo.seriesFlags[this.currentFlag];
    if (flag.episode.length === 0) return;

    const episode = flag.episode[this.currentEpisode];

    // Save watch history
    this.savePlayHistory();

    // Navigate to play page
    router.pushUrl({
      url: 'pages/PlayPage',
      params: {
        vodInfo: this.vodInfo,
        playFlag: flag.name,
        playIndex: this.currentEpisode,
        episodeUrl: episode.url
      }
    });
  }

  /**
   * Save play history
   */
  private async savePlayHistory() {
    const historyData = {
      vodId: this.videoId,
      sourceKey: this.sourceKey,
      name: this.vodInfo.name,
      pic: this.vodInfo.pic,
      playFlag: this.vodInfo.seriesFlags[this.currentFlag].name,
      playIndex: this.currentEpisode
    };

    await DatabaseManager.getInstance().saveVodRecord(
      this.videoId,
      this.sourceKey,
      JSON.stringify(historyData)
    );
  }

  /**
   * Navigate back
   */
  private goBack() {
    router.back();
  }

  build() {
    Column() {
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
        // Top bar
        Row() {
          Image($r('app.media.icon_back'))
            .width(24)
            .height(24)
            .onClick(() => this.goBack())

          Text('详情')
            .fontSize(20)
            .fontColor(Color.White)
            .margin({ left: 20 })

          Blank()

          Image(this.isCollected ? $r('app.media.icon_collected') : $r('app.media.icon_collect'))
            .width(24)
            .height(24)
            .onClick(() => this.toggleCollect())
        }
        .width('100%')
        .height(60)
        .padding({ left: 40, right: 40 })
        .backgroundColor('#1E1E1E')

        Scroll() {
          Column() {
            // Video info section
            Row() {
              // Poster
              Image(this.vodInfo.pic)
                .width(200)
                .height(280)
                .borderRadius(8)
                .objectFit(ImageFit.Cover)

              // Info
              Column({ space: 12 }) {
                Text(this.vodInfo.name)
                  .fontSize(28)
                  .fontColor(Color.White)
                  .fontWeight(FontWeight.Bold)

                if (this.vodInfo.note) {
                  Text(this.vodInfo.note)
                    .fontSize(16)
                    .fontColor('#BBFFFFFF')
                }

                Row({ space: 20 }) {
                  if (this.vodInfo.year) {
                    Text(this.vodInfo.year)
                      .fontSize(14)
                      .fontColor('#BBFFFFFF')
                  }
                  if (this.vodInfo.area) {
                    Text(this.vodInfo.area)
                      .fontSize(14)
                      .fontColor('#BBFFFFFF')
                  }
                  if (this.vodInfo.type) {
                    Text(this.vodInfo.type)
                      .fontSize(14)
                      .fontColor('#BBFFFFFF')
                  }
                }

                if (this.vodInfo.actor) {
                  Text(`演员: ${this.vodInfo.actor}`)
                    .fontSize(14)
                    .fontColor('#BBFFFFFF')
                    .maxLines(2)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                }

                if (this.vodInfo.director) {
                  Text(`导演: ${this.vodInfo.director}`)
                    .fontSize(14)
                    .fontColor('#BBFFFFFF')
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                }

                Button('立即播放')
                  .fontSize(16)
                  .fontColor(Color.White)
                  .backgroundColor('#FF5722')
                  .padding({ left: 30, right: 30, top: 10, bottom: 10 })
                  .borderRadius(8)
                  .onClick(() => this.startPlay())
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)
              .margin({ left: 30 })
            }
            .width('100%')
            .padding(30)
            .alignItems(VerticalAlign.Top)

            // Description
            if (this.vodInfo.des) {
              Column() {
                Text('剧情简介')
                  .fontSize(18)
                  .fontColor(Color.White)
                  .fontWeight(FontWeight.Bold)
                  .margin({ bottom: 10 })

                Text(this.vodInfo.des)
                  .fontSize(14)
                  .fontColor('#BBFFFFFF')
                  .lineHeight(22)
              }
              .width('100%')
              .padding({ left: 30, right: 30, bottom: 20 })
              .alignItems(HorizontalAlign.Start)
            }

            // Episode selection
            if (this.vodInfo.seriesFlags.length > 0) {
              Column() {
                // Source flags (m3u8, MP4, etc.)
                Row({ space: 10 }) {
                  ForEach(this.vodInfo.seriesFlags, (flag: VodSeriesFlag, index: number) => {
                    Text(flag.name)
                      .fontSize(16)
                      .fontColor(this.currentFlag === index ? Color.White : '#BBFFFFFF')
                      .fontWeight(this.currentFlag === index ? FontWeight.Bold : FontWeight.Normal)
                      .padding({ left: 20, right: 20, top: 8, bottom: 8 })
                      .borderRadius(8)
                      .backgroundColor(this.currentFlag === index ? '#FF5722' : '#333333')
                      .onClick(() => this.onFlagSelected(index))
                  }, (flag: VodSeriesFlag, index: number) => `${index}`)
                }
                .margin({ bottom: 20 })

                // Episodes grid
                Grid() {
                  ForEach(this.vodInfo.seriesFlags[this.currentFlag].episode, (episode: VodSeries, index: number) => {
                    GridItem() {
                      Text(episode.name)
                        .fontSize(14)
                        .fontColor(this.currentEpisode === index ? Color.White : '#BBFFFFFF')
                        .fontWeight(this.currentEpisode === index ? FontWeight.Bold : FontWeight.Normal)
                        .padding({ left: 15, right: 15, top: 10, bottom: 10 })
                        .borderRadius(6)
                        .backgroundColor(this.currentEpisode === index ? '#FF5722' : '#333333')
                        .textAlign(TextAlign.Center)
                    }
                    .onClick(() => this.onEpisodeSelected(index))
                  }, (episode: VodSeries, index: number) => `${index}`)
                }
                .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr')
                .rowsGap(10)
                .columnsGap(10)
                .width('100%')
              }
              .width('100%')
              .padding(30)
              .alignItems(HorizontalAlign.Start)
            }
          }
        }
        .layoutWeight(1)
        .scrollBar(BarState.Auto)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#000000')
  }
}

/**
 * Detail page params
 */
interface DetailParams {
  videoId: string;
  sourceKey: string;
}
