# Yandex Ads iOS Mobile Godot
**Yandex Mobile Ads SDK binding for Godot Engine 4.2+**  

A native plugin bridging Godot Engine with Yandex's advertising platform, providing seamless ad monetization for iOS games.  

---

## Installation  

1. Download the repo
2. Run the following terminal commands:
```
chmod +x build.sh
./build.sh ios debug   - for debug version
./build.sh ios release - for release version
```
3. Navigate to your Godot project and create a `bin` folder.
4. Copy `YandexiOSADSGodot.gdextension` from the root folder and `SwiftGodot.framework`,`Yandex-iOS-ADS-Godot.framework` (skip `YandexMobileAds.framework`) form Bin -> ios to the `bin` folder in Godot project
5. Export your iOS project from the Godot editor to a specific folder.
![Screenshot 2025-02-06 at 16 33 04](https://github.com/user-attachments/assets/ddd5f9b4-118a-49c2-94ee-2f2315e63ccd)

6. Copy `MobileAdsBundle.bundle` from this repository to the exported folder. Open the exported project in Xcode, navigate to your target settings, and add `MobileAdsBundle.bundle` to `Copy Bundle Resources`.

![Screenshot 2025-02-06 at 16 36 21](https://github.com/user-attachments/assets/0ff06214-5739-4007-a720-60648b7e8311)


7. Open Package Dependencies and add the package: `https://github.com/yandexmobile/yandex-ads-sdk-ios.`

**Important**: Set the exact version **7.8.0** because the `MobileAdsBundle.bundle` is taken from this version.

![Screenshot 2025-02-06 at 16 47 05](https://github.com/user-attachments/assets/9c5109c8-b82e-4c03-bbcb-7eb18253c759)


## Testing 
Open your Godot project and create a new script file. Use the following sample code.
```gdscript
extends Node2D

class_name YandexAdsiOS

const CLASS_NAME = "YandexAdsiOSGodot"

var native_lib: Variant = null

signal rewarded(amount: int, type: String)
signal rewarded_video_loaded
signal rewarded_video_failed_to_load(error: String)
signal rewarded_video_closed

signal interstitial_loaded
signal interstitial_failed_to_load(error: String)
signal interstitial_closed

signal banner_loaded
signal banner_failed_to_load(error: String)

var rewarded_id: String:
    get:
        if _if_lib_exists(): return native_lib.rewarded_id
        return ""
    set(_value):
        if _if_lib_exists(): native_lib.rewarded_id = _value

var banner_id: String:
    get:
        if _if_lib_exists(): return native_lib.banner_id
        return ""
    set(_value):
        if _if_lib_exists(): native_lib.banner_id = _value

var interstitial_id: String:
    get: 
        if _if_lib_exists(): return native_lib.interstitial_id
        return ""
    set(_value):
        if _if_lib_exists(): native_lib.interstitial_id = _value

func _subscribe_rewarded() -> void:
    native_lib.connect("rewarded", _on_rewarded) 
    native_lib.connect("rewarded_video_loaded", func(): rewarded_video_loaded.emit())
    native_lib.connect("rewarded_video_failed_to_load", func(x: String): rewarded_video_failed_to_load.emit(x))
    native_lib.connect("rewarded_video_closed", func(): rewarded_video_closed.emit())

func _subsctibe_interstitial() -> void:
    native_lib.connect("interstitial_loaded", func(): interstitial_loaded.emit())
    native_lib.connect("interstitial_failed_to_load", func(x: String): interstitial_failed_to_load.emit(x))
    native_lib.connect("interstitial_closed", func(): interstitial_closed.emit())

func _subscribe_banner() -> void:
    native_lib.connect("banner_loaded", func(): banner_loaded.emit())
    native_lib.connect("banner_failed_to_load", func(x: String): banner_failed_to_load.emit(x))

func initialize () -> void:
    if native_lib == null && ClassDB.class_exists(CLASS_NAME):
        native_lib = ClassDB.instantiate(CLASS_NAME)
        native_lib.initializeSDK()

        _subscribe_rewarded()
        _subsctibe_interstitial()
        _subscribe_banner()

### Banners
func load_banner() -> void:
    if _if_lib_exists(): native_lib.loadStickyBanner()

func show_banner() -> void:
    if _if_lib_exists(): native_lib.showStickyBanner()

func hide_banner() -> void:
    if _if_lib_exists(): native_lib.hideStickyBanner()

### Interstitial
func load_interstitial() -> void:
    if _if_lib_exists(): native_lib.loadInterstitialAd()

func show_interstitial() -> void:
    if _if_lib_exists(): native_lib.showInterstitialAd()

### Rewarded

func load_rewarded_video() -> void:
    if _if_lib_exists(): native_lib.loadRewardedAd()

func show_rewarded_video() -> void:
    if _if_lib_exists(): native_lib.showRewardedAd()

func _if_lib_exists() -> bool:
    return native_lib != null 

func _on_rewarded(_type: String, _amount: int) -> void:
    rewarded.emit(_amount, _type)
```

---
_Not affiliated with Yandex LLC. Mobile Ads SDK is property of Yandex._
