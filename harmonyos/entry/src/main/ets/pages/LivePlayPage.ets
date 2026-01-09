import router from '@ohos.router';
import { LiveChannelGroup, LiveChannelItem } from '../model/SourceBean';
import media from '@ohos.multimedia.media';

/**
 * LivePlayPage - Live TV playback page
 * Converted from Android LivePlayActivity.java
 */
@Entry
@Component
struct LivePlayPage {
  @State channelGroups: LiveChannelGroup[] = [];
  @State currentGroup: number = 0;
  @State currentChannel: number = 0;
  @State showChannelList: boolean = false;
  @State isPlaying: boolean = false;

  private avPlayer: media.AVPlayer | null = null;

  aboutToAppear() {
    this.loadChannels();
  }

  aboutToDisappear() {
    this.releasePlayer();
  }

  /**
   * Load live channels
   */
  private loadChannels() {
    // TODO: Load live channel configuration
    // This will parse live channel data from API
    this.channelGroups = [];
  }

  /**
   * Initialize video player
   */
  private async initPlayer(url: string) {
    try {
      if (this.avPlayer) {
        await this.releasePlayer();
      }

      this.avPlayer = await media.createAVPlayer();

      this.avPlayer.on('stateChange', (state: media.AVPlayerState) => {
        console.info(`AVPlayer state changed to: ${state}`);
        if (state === 'playing') {
          this.isPlaying = true;
        } else if (state === 'paused' || state === 'stopped') {
          this.isPlaying = false;
        }
      });

      this.avPlayer.on('error', (err) => {
        console.error(`AVPlayer error: ${JSON.stringify(err)}`);
      });

      this.avPlayer.url = url;
      await this.avPlayer.play();

    } catch (err) {
      console.error(`Failed to initialize player: ${JSON.stringify(err)}`);
    }
  }

  /**
   * Release video player
   */
  private async releasePlayer() {
    if (this.avPlayer) {
      await this.avPlayer.release();
      this.avPlayer = null;
    }
  }

  /**
   * Switch to channel
   */
  private switchChannel(groupIndex: number, channelIndex: number) {
    this.currentGroup = groupIndex;
    this.currentChannel = channelIndex;

    const channel = this.channelGroups[groupIndex].liveChannels[channelIndex];
    const url = channel.getCurrentUrl();

    this.initPlayer(url);
    this.showChannelList = false;
  }

  /**
   * Switch to next channel
   */
  private nextChannel() {
    const group = this.channelGroups[this.currentGroup];
    if (this.currentChannel < group.liveChannels.length - 1) {
      this.switchChannel(this.currentGroup, this.currentChannel + 1);
    }
  }

  /**
   * Switch to previous channel
   */
  private previousChannel() {
    if (this.currentChannel > 0) {
      this.switchChannel(this.currentGroup, this.currentChannel - 1);
    }
  }

  /**
   * Toggle channel list
   */
  private toggleChannelList() {
    this.showChannelList = !this.showChannelList;
  }

  /**
   * Navigate back
   */
  private goBack() {
    router.back();
  }

  build() {
    Stack() {
      // Video container
      Column() {
        XComponent({
          id: 'live_player',
          type: 'surface',
          libraryname: ''
        })
          .width('100%')
          .height('100%')
          .backgroundColor(Color.Black)
      }
      .width('100%')
      .height('100%')

      // Channel list overlay
      if (this.showChannelList) {
        Row() {
          // Channel groups
          List() {
            ForEach(this.channelGroups, (group: LiveChannelGroup, groupIndex: number) => {
              ListItem() {
                Text(group.groupName)
                  .fontSize(16)
                  .fontColor(this.currentGroup === groupIndex ? Color.White : '#BBFFFFFF')
                  .fontWeight(this.currentGroup === groupIndex ? FontWeight.Bold : FontWeight.Normal)
                  .padding({ left: 15, right: 15, top: 10, bottom: 10 })
                  .borderRadius(6)
                  .backgroundColor(this.currentGroup === groupIndex ? '#FF5722' : 'transparent')
              }
              .onClick(() => {
                this.currentGroup = groupIndex;
                this.currentChannel = 0;
              })
            }, (group: LiveChannelGroup, index: number) => `${index}`)
          }
          .width(150)
          .height('100%')
          .backgroundColor('rgba(0, 0, 0, 0.9)')
          .padding(10)

          // Channels in selected group
          List() {
            ForEach(this.channelGroups[this.currentGroup]?.liveChannels || [], (channel: LiveChannelItem, channelIndex: number) => {
              ListItem() {
                Row() {
                  Text(`${channel.channelNum}`)
                    .fontSize(14)
                    .fontColor('#BBFFFFFF')
                    .width(40)

                  Text(channel.channelName)
                    .fontSize(16)
                    .fontColor(this.currentChannel === channelIndex ? Color.White : '#BBFFFFFF')
                    .fontWeight(this.currentChannel === channelIndex ? FontWeight.Bold : FontWeight.Normal)
                }
                .width('100%')
                .padding({ left: 15, right: 15, top: 10, bottom: 10 })
                .borderRadius(6)
                .backgroundColor(this.currentChannel === channelIndex ? '#FF5722' : 'transparent')
              }
              .onClick(() => this.switchChannel(this.currentGroup, channelIndex))
            }, (channel: LiveChannelItem, index: number) => `${index}`)
          }
          .layoutWeight(1)
          .height('100%')
          .backgroundColor('rgba(0, 0, 0, 0.9)')
          .padding(10)
        }
        .width(500)
        .height('100%')
      }

      // Top bar
      Row() {
        Text('←')
          .fontSize(24)
          .fontColor(Color.White)
          .onClick(() => this.goBack())

        if (this.channelGroups.length > 0 && this.channelGroups[this.currentGroup]) {
          Text(this.channelGroups[this.currentGroup].liveChannels[this.currentChannel]?.channelName || '')
            .fontSize(18)
            .fontColor(Color.White)
            .margin({ left: 20 })
        }

        Blank()

        Text('≡')
          .fontSize(24)
          .fontColor(Color.White)
          .onClick(() => this.toggleChannelList())
      }
      .width('100%')
      .padding({ left: 30, right: 30, top: 20, bottom: 20 })
      .backgroundColor('rgba(0, 0, 0, 0.7)')

      // Center controls (channel switch)
      Row({ space: 60 }) {
        Text('◀')
          .fontSize(40)
          .fontColor(Color.White)
          .onClick(() => this.previousChannel())

        Text('▶')
          .fontSize(40)
          .fontColor(Color.White)
          .onClick(() => this.nextChannel())
      }
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Black)
  }
}
