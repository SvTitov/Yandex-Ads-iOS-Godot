# Godot Yandex Ads iOS Mobile  
**Yandex Mobile Ads SDK integration for Godot Engine 4.2+**  

A native plugin bridging Godot Engine with Yandex's advertising platform, providing seamless ad monetization for iOS games.  

---

## Installation  

1. Download the repo
2. Run the following terminal commands:
```
chmod +x build.sh
/.build.sh ios debug   - for debug version
/.build.sh ios release - for release version
```
3. Navigate to your Godot project and create a `bin` folder.
4. Copy `YandexiOSADSGodot.gdextension` from the root folder and `SwiftGodot.framework`,`Yandex-iOS-ADS-Godot.framework` form Bin -> ios to the `bin` folder in Godot project
5. Export your iOS project from the Godot editor to a specific folder.
6. Copy `MobileAdsBundle.bundle` from this repository to the exported folder. Open the exported project in Xcode, navigate to your target settings, and add `MobileAdsBundle.bundle` to `Copy Bundle Resources`.
7. Open Package Dependencies and add the package: `https://github.com/yandexmobile/yandex-ads-sdk-ios.`
   **Important**: Set the exact version 7.8.0 because the MobileAdsBundle.bundle is taken from this version.

## Testing 
Open your Godot project and create a new script file. Use the following sample code.
```gdscript
extends Node2D

class_name iOS_Ads

const CLASS_NAME = "YandexAds"

var _my_library: Variant = null

func _init():
    if _my_library == null && ClassDB.class_exists(CLASS_NAME):
        _my_library = ClassDB.instantiate (CLASS_NAME)
        _my_library.connect("on_reward", _on_reward) 

func initialize () -> void:
    if _my_library != null:
        _my_library.initializeSDK()

func show_sticky_banner(_ad_unit_id: String) -> void:
    if _my_library != null:
        _my_library.showStickyBanner(_ad_unit_id)

func showInterstitialAd(_ad_unit_id: String) -> void:
    if _my_library != null:
        _my_library.showInterstitialAd(_ad_unit_id)

func showRewaredAd(_ad_unit_id: String) -> void:
    if _my_library != null:
        _my_library.showRewardedAd(_ad_unit_id)

func _on_reward(_amount: int, _type: String) -> void:
    print_debug("Amount: ", _amount, " Type: ", _type)
```

---
_Not affiliated with Yandex LLC. Mobile Ads SDK is property of Yandex._
