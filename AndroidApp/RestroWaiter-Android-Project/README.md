# RestroWaiter Android APK

Companion APK for SageFrame RestroOrder dining modules.

### How to build:
1. Open Android Studio.
2. Select **Open an Existing Project** and choose this folder.
3. Allow Gradle sync to complete.
4. Run:
   ```bash
   ./gradlew assembleDebug
   ```
5. Output APK: `app/build/outputs/apk/debug/app-debug.apk`.

### Deploying to Tablets:
```bash
adb install -r app/build/outputs/apk/debug/app-debug.apk
```
