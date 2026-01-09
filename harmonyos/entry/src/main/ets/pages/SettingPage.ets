import router from '@ohos.router';
import { PreferenceManager } from '../common/PreferenceManager';

/**
 * SettingPage - Settings page
 * Converted from Android SettingActivity.java
 */
@Entry
@Component
struct SettingPage {
  @State apiUrl: string = '';
  @State playType: number = 0;
  @State ijkCodec: string = '';
  @State playScale: number = 0;

  aboutToAppear() {
    this.loadSettings();
  }

  /**
   * Load current settings
   */
  private async loadSettings() {
    this.apiUrl = await PreferenceManager.getInstance().getString(PreferenceManager.KEY_API_URL);
    this.playType = await PreferenceManager.getInstance().getNumber(PreferenceManager.KEY_PLAY_TYPE, 0);
    this.ijkCodec = await PreferenceManager.getInstance().getString(PreferenceManager.KEY_IJK_CODEC, 'default');
    this.playScale = await PreferenceManager.getInstance().getNumber(PreferenceManager.KEY_PLAY_SCALE, 0);
  }

  /**
   * Save API URL
   */
  private async saveApiUrl() {
    if (this.apiUrl.trim()) {
      await PreferenceManager.getInstance().putString(PreferenceManager.KEY_API_URL, this.apiUrl);
      // TODO: Reload API config
    }
  }

  /**
   * Save play type
   */
  private async savePlayType(type: number) {
    this.playType = type;
    await PreferenceManager.getInstance().putNumber(PreferenceManager.KEY_PLAY_TYPE, type);
  }

  /**
   * Save play scale
   */
  private async savePlayScale(scale: number) {
    this.playScale = scale;
    await PreferenceManager.getInstance().putNumber(PreferenceManager.KEY_PLAY_SCALE, scale);
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
          .width(24)
          
          .onClick(() => this.goBack())

        Text('设置')
          .fontSize(20)
          .fontColor(Color.White)
          .margin({ left: 20 })
      }
      .width('100%')
      .height(60)
      .padding({ left: 40, right: 40 })
      .backgroundColor('#1E1E1E')

      Scroll() {
        Column({ space: 0 }) {
          // API URL setting
          Column() {
            Text('数据源配置')
              .fontSize(16)
              .fontColor(Color.White)
              .fontWeight(FontWeight.Bold)
              .width('100%')
              .margin({ bottom: 15 })

            TextInput({ placeholder: '请输入数据源API地址', text: this.apiUrl })
              .width('100%')
              .height(45)
              .backgroundColor('#333333')
              .placeholderColor('#888888')
              .fontColor(Color.White)
              .onChange((value: string) => {
                this.apiUrl = value;
              })

            Button('保存配置')
              .width('100%')
              .height(45)
              .fontSize(16)
              .fontColor(Color.White)
              .backgroundColor('#FF5722')
              .margin({ top: 15 })
              .onClick(() => this.saveApiUrl())
          }
          .width('100%')
          .padding(20)
          .margin({ top: 20 })
          .borderRadius(8)
          .backgroundColor('#1E1E1E')

          // Player settings
          Column() {
            Text('播放器设置')
              .fontSize(16)
              .fontColor(Color.White)
              .fontWeight(FontWeight.Bold)
              .width('100%')
              .margin({ bottom: 15 })

            // Play type
            Column() {
              Text('播放器类型')
                .fontSize(14)
                .fontColor('#BBFFFFFF')
                .width('100%')
                .margin({ bottom: 10 })

              Row({ space: 10 }) {
                Button('系统播放器')
                  .fontSize(14)
                  .fontColor(this.playType === 0 ? Color.White : '#BBFFFFFF')
                  .backgroundColor(this.playType === 0 ? '#FF5722' : '#333333')
                  .onClick(() => this.savePlayType(0))

                Button('IJK硬解')
                  .fontSize(14)
                  .fontColor(this.playType === 1 ? Color.White : '#BBFFFFFF')
                  .backgroundColor(this.playType === 1 ? '#FF5722' : '#333333')
                  .onClick(() => this.savePlayType(1))

                Button('IJK软解')
                  .fontSize(14)
                  .fontColor(this.playType === 2 ? Color.White : '#BBFFFFFF')
                  .backgroundColor(this.playType === 2 ? '#FF5722' : '#333333')
                  .onClick(() => this.savePlayType(2))
              }
            }
            .width('100%')
            .margin({ bottom: 20 })

            // Play scale
            Column() {
              Text('画面缩放')
                .fontSize(14)
                .fontColor('#BBFFFFFF')
                .width('100%')
                .margin({ bottom: 10 })

              Row({ space: 10 }) {
                Button('默认')
                  .fontSize(14)
                  .fontColor(this.playScale === 0 ? Color.White : '#BBFFFFFF')
                  .backgroundColor(this.playScale === 0 ? '#FF5722' : '#333333')
                  .onClick(() => this.savePlayScale(0))

                Button('16:9')
                  .fontSize(14)
                  .fontColor(this.playScale === 1 ? Color.White : '#BBFFFFFF')
                  .backgroundColor(this.playScale === 1 ? '#FF5722' : '#333333')
                  .onClick(() => this.savePlayScale(1))

                Button('4:3')
                  .fontSize(14)
                  .fontColor(this.playScale === 2 ? Color.White : '#BBFFFFFF')
                  .backgroundColor(this.playScale === 2 ? '#FF5722' : '#333333')
                  .onClick(() => this.savePlayScale(2))

                Button('填充')
                  .fontSize(14)
                  .fontColor(this.playScale === 3 ? Color.White : '#BBFFFFFF')
                  .backgroundColor(this.playScale === 3 ? '#FF5722' : '#333333')
                  .onClick(() => this.savePlayScale(3))
              }
            }
            .width('100%')
          }
          .width('100%')
          .padding(20)
          .margin({ top: 20 })
          .borderRadius(8)
          .backgroundColor('#1E1E1E')

          // About
          Column() {
            Text('关于')
              .fontSize(16)
              .fontColor(Color.White)
              .fontWeight(FontWeight.Bold)
              .width('100%')
              .margin({ bottom: 15 })

            Row() {
              Text('版本')
                .fontSize(14)
                .fontColor('#BBFFFFFF')

              Blank()

              Text('1.0.0')
                .fontSize(14)
                .fontColor(Color.White)
            }
            .width('100%')
            .margin({ bottom: 10 })

            Row() {
              Text('平台')
                .fontSize(14)
                .fontColor('#BBFFFFFF')

              Blank()

              Text('HarmonyOS Next')
                .fontSize(14)
                .fontColor(Color.White)
            }
            .width('100%')
          }
          .width('100%')
          .padding(20)
          .margin({ top: 20, bottom: 30 })
          .borderRadius(8)
          .backgroundColor('#1E1E1E')
        }
        .width('100%')
        .padding({ left: 30, right: 30 })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Auto)
      .backgroundColor('#000000')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#000000')
  }
}
