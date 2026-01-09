import router from '@ohos.router';
import media from '@ohos.multimedia.media';

/**
 * PushPage - Remote push playback page
 * Converted from Android PushActivity.java
 * Handles content pushed from external sources
 */
@Entry
@Component
struct PushPage {
  @State pushUrl: string = '';
  @State isPlaying: boolean = false;
  @State currentTime: number = 0;
  @State duration: number = 0;
  @State showController: boolean = true;

  private avPlayer: media.AVPlayer | null = null;
  private hideControllerTimer: number = -1;

  aboutToAppear() {
    const params = router.getParams() as PushParams;
    if (params && params.url) {
      this.pushUrl = params.url;
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

      this.avPlayer.on('stateChange', (state: media.AVPlayerState) => {
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

      this.avPlayer.url = this.pushUrl;
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
   * Toggle play/pause
   */
  private async togglePlayPause() {
    if (!this.avPlayer) return;

    if (this.isPlaying) {
      await this.avPlayer.pause();
    } else {
      await this.avPlayer.play();
      this.resetHideControllerTimer();
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
   * Format time
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
    router.back();
  }

  build() {
    Stack() {
      // Video container
      Column() {
        XComponent({
          id: 'push_player',
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
            Text('←')
              .fontSize(24)
              .fontColor(Color.White)
              .onClick(() => this.goBack())

            Text('远程推送')
              .fontSize(18)
              .fontColor(Color.White)
              .margin({ left: 20 })
          }
          .width('100%')
          .padding({ left: 30, right: 30, top: 20, bottom: 20 })
          .backgroundColor('rgba(0, 0, 0, 0.7)')

          Blank()

          // Center play/pause button
          Text(this.isPlaying ? '❚❚' : '▶')
            .fontSize(60)
            .fontColor(Color.White)
            .onClick(() => this.togglePlayPause())

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
 * Push page params
 */
interface PushParams {
  url: string;
}
