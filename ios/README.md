# iOS 

## Configuration
- bundle id: `net.yunlu18.hsrwikiproject`

## Setup

```zsh
# A. start via xcode
cd <repo>
cd ios
pod install --repo-update
open Runner.xcworkspace
# select your dev team account 
# cmd + R

# B. start via flutter
cd <repo>
flutter build ios
flutter run 
# select iOS simulator

# C. archive via flutter
cd <repo>
flutter build ipa
# upload the ipa via Xcode / App Uploader
```