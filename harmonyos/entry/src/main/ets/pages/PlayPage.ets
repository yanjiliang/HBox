import router from '@ohos.router';
import { VodInfo } from '../model/VodInfo';
import { DatabaseManager } from '../database/DatabaseManager';
import media from '@ohos.multimedia.media';

/**
 * PlayPage - Video playback page
 * Converted from Android PlayActivity.java
 * Uses HarmonyOS native video player (AVPlayer)
 */
@Entry
@Component
struct PlayPage {
  @State vodInfo: VodInfo = new VodInfo();
  @State playFlag: string = '';
  @State playIndex: number = 0;
  @State episodeUrl: string = '';
  @State isPlaying: boolean = false;
  @State showController: boolean = true;
  @State currentTime: number = 0;
  @State duration: number = 0;
  @State isFullscreen: boolean = true;

  private avPlayer: media.AVPlayer | null = null;
  private videoId: string = '';
  private sourceKey: string = '';
  private hideControllerTimer: number = -1;

  aboutToAppear() {
    const params = router.getParams() as PlayParams;
    if (params) {
      this.vodInfo = params.vodInfo;
      this.playFlag = params.playFlag;
      this.playIndex = params.playIndex;
      this.episodeUrl = params.episodeUrl;
      this.videoId = this.vodInfo.id;
      this.sourceKey = this.vodInfo.sourceKey;

      this.initPlayer();
    }
  }

  aboutToDisappear() {
    this.releasePlayer();
    if (this.hideControllerTimer !== -1) {
      clearTimeout(this.hideControllerTimer);
    }
  }

  /**
   * Initialize video player
   */
  private async initPlayer() {
    try {
      this.avPlayer = await media.createAVPlayer();

      // Set up player callbacks
      this.avPlayer.on('stateChange', (state: media.AVPlayerState) => {
        console.info(`AVPlayer state changed to: ${state}`);
        if (state === 'playing') {
          this.isPlaying = true;
        } else if (state === 'paused' || state === 'stopped') {
          this.isPlaying = false;
        }
      });

      this.avPlayer.on('timeUpdate', (time: number) => {
        this.currentTime = time;
      });

      this.avPlayer.on('durationUpdate', (duration: number) => {
        this.duration = duration;
      });

      this.avPlayer.on('error', (err) => {
        console.error(`AVPlayer error: ${JSON.stringify(err)}`);
      });

      // Set video URL
      this.avPlayer.url = this.episodeUrl;

      // Auto-hide controller after 5 seconds
      this.resetHideControllerTimer();

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
   * Play video
   */
  private async play() {
    if (this.avPlayer) {
      await this.avPlayer.play();
      this.resetHideControllerTimer();
    }
  }

  /**
   * Pause video
   */
  private async pause() {
    if (this.avPlayer) {
      await this.avPlayer.pause();
      if (this.hideControllerTimer !== -1) {
        clearTimeout(this.hideControllerTimer);
      }
    }
  }

  /**
   * Toggle play/pause
   */
  private async togglePlayPause() {
    if (this.isPlaying) {
      await this.pause();
    } else {
      await this.play();
    }
  }

  /**
   * Seek to position
   */
  private async seekTo(position: number) {
    if (this.avPlayer) {
      await this.avPlayer.seek(position);
    }
  }

  /**
   * Fast forward
   */
  private async fastForward() {
    const newTime = Math.min(this.currentTime + 15000, this.duration);
    await this.seekTo(newTime);
  }

  /**
   * Rewind
   */
  private async rewind() {
    const newTime = Math.max(this.currentTime - 15000, 0);
    await this.seekTo(newTime);
  }

  /**
   * Play next episode
   */
  private playNext() {
    const currentFlag = this.vodInfo.seriesFlags.find(f => f.name === this.playFlag);
    if (currentFlag && this.playIndex < currentFlag.episode.length - 1) {
      this.playIndex++;
      const nextEpisode = currentFlag.episode[this.playIndex];
      this.episodeUrl = nextEpisode.url;
      this.releasePlayer().then(() => {
        this.initPlayer();
      });
    }
  }

  /**
   * Play previous episode
   */
  private playPrevious() {
    if (this.playIndex > 0) {
      this.playIndex--;
      const currentFlag = this.vodInfo.seriesFlags.find(f => f.name === this.playFlag);
      if (currentFlag) {
        const prevEpisode = currentFlag.episode[this.playIndex];
        this.episodeUrl = prevEpisode.url;
        this.releasePlayer().then(() => {
          this.initPlayer();
        });
      }
    }
  }

  /**
   * Toggle controller visibility
   */
  private toggleController() {
    this.showController = !this.showController;
    if (this.showController) {
      this.resetHideControllerTimer();
    }
  }

  /**
   * Reset hide controller timer
   */
  private resetHideControllerTimer() {
    if (this.hideControllerTimer !== -1) {
      clearTimeout(this.hideControllerTimer);
    }

    this.hideControllerTimer = setTimeout(() => {
      if (this.isPlaying) {
        this.showController = false;
      }
    }, 5000);
  }

  /**
   * Format time (ms to mm:ss)
   */
  private formatTime(ms: number): string {
    const totalSeconds = Math.floor(ms / 1000);
    const minutes = Math.floor(totalSeconds / 60);
    const seconds = totalSeconds % 60;
    return `${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`;
  }

  /**
   * Navigate back
   */
  private goBack() {
    // Save play progress
    this.savePlayProgress();
    router.back();
  }

  /**
   * Save play progress
   */
  private async savePlayProgress() {
    const historyData = {
      vodId: this.videoId,
      sourceKey: this.sourceKey,
      name: this.vodInfo.name,
      pic: this.vodInfo.pic,
      playFlag: this.playFlag,
      playIndex: this.playIndex,
      playPosition: this.currentTime
    };

    await DatabaseManager.getInstance().saveVodRecord(
      this.videoId,
      this.sourceKey,
      JSON.stringify(historyData)
    );
  }

  build() {
    Stack() {
      // Video container (XComponent for native player surface)
      Column() {
        XComponent({
          id: 'video_player',
          type: 'surface',
          libraryname: ''
        })
          .width('100%')
          .height('100%')
          .backgroundColor(Color.Black)
      }
      .width('100%')
      .height('100%')

      // Controller overlay
      if (this.showController) {
        Column() {
          // Top bar
          Row() {
            Image($r('app.media.icon_back'))
              .width(24)
              .height(24)
              .fillColor(Color.White)
              .onClick(() => this.goBack())

            Text(this.vodInfo.name)
              .fontSize(18)
              .fontColor(Color.White)
              .margin({ left: 20 })

            Blank()

            Text(`${this.playIndex + 1}/${this.vodInfo.seriesFlags.find(f => f.name === this.playFlag)?.episode.length || 0}`)
              .fontSize(16)
              .fontColor(Color.White)
          }
          .width('100%')
          .padding({ left: 30, right: 30, top: 20, bottom: 20 })
          .backgroundColor('rgba(0, 0, 0, 0.7)')

          Blank()

          // Center controls
          Row({ space: 60 }) {
            Image($r('app.media.icon_previous'))
              .width(40)
              .height(40)
              .fillColor(Color.White)
              .onClick(() => this.playPrevious())

            Image($r('app.media.icon_rewind'))
              .width(40)
              .height(40)
              .fillColor(Color.White)
              .onClick(() => this.rewind())

            Image(this.isPlaying ? $r('app.media.icon_pause') : $r('app.media.icon_play'))
              .width(60)
              .height(60)
              .fillColor(Color.White)
              .onClick(() => this.togglePlayPause())

            Image($r('app.media.icon_forward'))
              .width(40)
              .height(40)
              .fillColor(Color.White)
              .onClick(() => this.fastForward())

            Image($r('app.media.icon_next'))
              .width(40)
              .height(40)
              .fillColor(Color.White)
              .onClick(() => this.playNext())
          }
          .justifyContent(FlexAlign.Center)

          Blank()

          // Bottom progress bar
          Column() {
            Row() {
              Text(this.formatTime(this.currentTime))
                .fontSize(14)
                .fontColor(Color.White)

              Slider({
                value: this.currentTime,
                min: 0,
                max: this.duration,
                step: 1000,
                style: SliderStyle.OutSet
              })
                .blockColor(Color.White)
                .trackColor('#4D4D4D')
                .selectedColor('#FF5722')
                .layoutWeight(1)
                .margin({ left: 15, right: 15 })
                .onChange((value: number) => {
                  this.seekTo(value);
                })

              Text(this.formatTime(this.duration))
                .fontSize(14)
                .fontColor(Color.White)
            }
            .width('100%')
            .alignItems(VerticalAlign.Center)
          }
          .width('100%')
          .padding({ left: 30, right: 30, bottom: 20 })
          .backgroundColor('rgba(0, 0, 0, 0.7)')
        }
        .width('100%')
        .height('100%')
      }

      // Tap to toggle controller
      Column()
        .width('100%')
        .height('100%')
        .onClick(() => this.toggleController())
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Black)
  }
}

/**
 * Play page params
 */
interface PlayParams {
  vodInfo: VodInfo;
  playFlag: string;
  playIndex: number;
  episodeUrl: string;
}
