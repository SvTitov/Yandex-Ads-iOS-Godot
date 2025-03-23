import Foundation
import YandexMobileAds
import SwiftGodot

#initSwiftExtension(cdecl: "swift_entry_point", types: [YandexAdsiOSGodot.self])

@Godot
class YandexAdsiOSGodot: RefCounted {
    // --Rewarded
    #signal("rewarded", arguments: ["type": String.self, "amount": Int.self])
    #signal("rewarded_video_loaded")
    #signal("rewarded_video_failed_to_load", arguments: ["error": String.self])
    #signal("rewarded_video_closed")
    
    // -- Interstitial
    #signal("interstitial_loaded")
    #signal("interstitial_failed_to_load", arguments: ["error": String.self])
    #signal("interstitial_closed")
    
    // --  Banner
    #signal("banner_loaded")
    #signal("banner_failed_to_load", arguments: ["error": String.self])

    @Export
    var banner_id : String = ""
    
    @Export
    var rewarded_id : String = ""
    
    @Export
    var interstitial_id : String = ""
    
    var rewardController: RewardedViewController?
    var interstitialVC  : InterstitialViewController?
    var stickyBannerVC  : StickyBannerViewController?
    
    @Callable
    func initializeSDK() {
        print(">>> YandexMobileAds \(#function)")
        MobileAds.initializeSDK(completionHandler: initializeFinished)
        MobileAds.enableLogging()
    }
    
    func initializeFinished() {
        print(">>> YandexMobileAds init finished")
    }
    
        @Callable
    func loadStickyBanner() {
        print(">>> YandexMobileAds \(#function)")
        stickyBannerVC = StickyBannerViewController()
        stickyBannerVC?.setLoadedCallback {
            let signal = SignalWithNoArguments("banner_loaded")
            self.emit(signal: signal)
        }
        stickyBannerVC?.setFailCallback { error in
            let signal = SignalWith1Argument<String>("banner_failed_to_load")
            self.emit(signal: signal, error)
        }
        stickyBannerVC?.loadAd(banner_id)
    }
    
    @Callable
    func showStickyBanner() {
        print(">>> YandexMobileAds \(#function)")
        
        guard let topViewController = UIViewController.topViewController, let stickyBannerVC else {
            fatalError("ViewController not found!")
        }
        
        stickyBannerVC.showAd(viewController: topViewController)
    }
    
    @Callable
    func hideStickyBanner() {
        print(">>> YandexMobileAds \(#function)")
        
        guard let topViewController = UIViewController.topViewController, let stickyBannerVC else {
            fatalError("ViewController not found!")
        }
        
        stickyBannerVC.hideAd(viewController: topViewController)
    }
    
    
    @Callable
    func loadInterstitialAd() {
        print(">>> YandexMobileAds \(#function)")
        interstitialVC = InterstitialViewController()
        interstitialVC?.setAdUnitID(interstitial_id)
        interstitialVC?.setLoadedCallback {
            let signal = SignalWithNoArguments("interstitial_loaded")
            self.emit(signal: signal)
        }
        interstitialVC?.setFailCallback { error in
            let signal = SignalWith1Argument<String>("interstitial_failed_to_load")
            self.emit(signal: signal, error)
        }
        interstitialVC?.loadAd()
    }
    
    @Callable
    func showInterstitialAd() {
        print(">>> YandexMobileAds \(#function)")
        
        guard let topViewController = UIViewController.topViewController, let interstitialVC else {
            fatalError("ViewController not found!")
        }
        
        topViewController.present(interstitialVC, animated: false)
        interstitialVC.setCloseCallback {
            let signal = SignalWithNoArguments("interstitial_closed")
            self.emit(signal: signal)
        }
        interstitialVC.showAd()
    }
    
    
    @Callable
    func loadRewardedAd() {
        print(">>> YandexMobileAds \(#function)")
        rewardController = RewardedViewController()
        rewardController?.setAdUnitID(rewarded_id)
        rewardController?.setVideoLoaded {
            let signal = SignalWithNoArguments("rewarded_video_loaded")
            self.emit(signal: signal)
        }
        rewardController?.setFailLoad { error in
            let signal = SignalWith1Argument<String>("rewarded_video_failed_to_load")
            self.emit(signal: signal, error)
        }
        rewardController?.setRewardCallback(onReward)
        rewardController?.loadAd()
    }
    
    @Callable
    func showRewardedAd() {
        print(">>> YandexMobileAds \(#function)")
        
        guard let topViewController = UIViewController.topViewController, let rewardController else {
            fatalError("ViewController not found!")
        }
        
        rewardController.setCloseCallback {
            let signal = SignalWithNoArguments("rewarded_video_closed")
            self.emit(signal: signal)
        }
        topViewController.present(rewardController, animated: false)
        rewardController.showAd()
    }
    
    func onReward(_ amount: Int, _ type: String) {
        let signal = SignalWith2Arguments<String, Int>("rewarded")
        emit(signal: signal, type, amount)
    }
}
