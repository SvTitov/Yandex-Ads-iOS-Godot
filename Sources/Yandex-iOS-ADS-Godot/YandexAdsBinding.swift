import Foundation
import YandexMobileAds
import SwiftGodot

#initSwiftExtension(cdecl: "swift_entry_point", types: [YandexAds.self])

@Godot
class YandexAds: RefCounted {
    #signal("on_reward", arguments: ["amount": Int.self, "type": String.self])

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
    func showStickyBanner(adUnitID: String) {
        print(">>> YandexMobileAds \(#function)")
        
        guard let topViewController = UIViewController.topViewController else {
            fatalError("ViewController not found!")
        }
        
        let stickyBannerVC = StickyBannerViewController()
        stickyBannerVC.loadAd(adUnitID)
        stickyBannerVC.showAd(viewController: topViewController)
    }
    
    @Callable
    func showInterstitialAd(adUnitID: String) {
        print(">>> YandexMobileAds \(#function)")
        
        guard let topViewController = UIViewController.topViewController else {
            fatalError("ViewController not found!")
        }
        
        let interstitialVC = InterstitialViewController()
        interstitialVC.setAdUnitID(adUnitID)
        topViewController.present(interstitialVC, animated: false)
    }
    
    @Callable
    func showRewardedAd(adUnitID: String) {
        print(">>> YandexMobileAds \(#function)")
        
        guard let topViewController = UIViewController.topViewController else {
            fatalError("ViewController not found!")
        }
        
        let interstitialVC = RewardedViewController()
        interstitialVC.setAdUnitID(adUnitID)
        interstitialVC.setRewardCallback(onReward)
        topViewController.present(interstitialVC, animated: false)
    }
    
    func onReward(_ amount: Int, _ type: String) {
        let signal = SignalWith2Arguments<Int, String>("on_reward")
        emit(signal: signal, amount, type)
    }
}
