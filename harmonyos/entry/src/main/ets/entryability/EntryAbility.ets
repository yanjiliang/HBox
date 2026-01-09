import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import { DatabaseManager } from '../database/DatabaseManager';
import { PreferenceManager } from '../common/PreferenceManager';

const TAG = 'EntryAbility';
const DOMAIN = 0xFF00;

export default class EntryAbility extends UIAbility {
  onCreate(want, launchParam) {
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onCreate');

    // Initialize database
    DatabaseManager.getInstance().init(this.context);

    // Initialize preferences
    PreferenceManager.getInstance().init(this.context);
  }

  onDestroy() {
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/HomePage', (err, data) => {
      if (err.code) {
        hilog.error(DOMAIN, TAG, 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }

      // Set window to fullscreen immersive mode for TV experience
      windowStage.getMainWindow((err, windowClass) => {
        if (err.code) {
          hilog.error(DOMAIN, TAG, 'Failed to obtain the main window. Cause: %{public}s', JSON.stringify(err) ?? '');
          return;
        }

        // Set fullscreen
        windowClass.setWindowLayoutFullScreen(true);

        // Hide status bar and navigation bar
        windowClass.setWindowSystemBarEnable([]);

        hilog.info(DOMAIN, TAG, 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
      });
    });
  }

  onWindowStageDestroy() {
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    hilog.info(DOMAIN, TAG, '%{public}s', 'Ability onBackground');
  }
}
