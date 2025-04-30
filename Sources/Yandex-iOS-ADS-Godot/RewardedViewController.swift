import Foundation
import UIKit
import YandexMobileAds

class RewardedViewController: UIViewController {
    private var rewardedAd: RewardedAd?
    private var rewardedCallback: ((Int, String) -> Void)?
    private var videoLoadedCallback : (() -> Void)?
    private var failLoadCallback : ((String) -> Void)?
    private var closeCallback : (() -> Void)?
    
    private lazy var rewardedAdLoader: RewardedAdLoader = {
        let loader = RewardedAdLoader()
        loader.delegate = self
        return loader
    }()
    
    private var adUnitID: String = ""
    
    func setAdUnitID(_ adUnitID: String) {
        self.adUnitID = adUnitID
    }
    
    func setRewardCallback(_ callback: @escaping (Int, String) -> Void) {
        self.rewardedCallback = callback
    }
    
    func setVideoLoaded(_ callback: @escaping () -> Void) {
        self.videoLoadedCallback = callback
    }
    
    func setFailLoad(_ callback: @escaping (String) -> Void) {
        self.failLoadCallback = callback
    }
    
    func setCloseCallback(_ callback: @escaping () -> Void) {
        self.closeCallback = callback
    }
    
    func loadAd() {
        let configuration = AdRequestConfiguration(adUnitID: adUnitID)
        rewardedAdLoader.loadAd(with: configuration)
    }
    
    func showAd() {
        DispatchQueue.main.async {
            self.rewardedAd?.show(from: self)
        }
    }
}

extension RewardedViewController: RewardedAdLoaderDelegate {
    func rewardedAdLoader(_ adLoader: RewardedAdLoader, didLoad rewardedAd: RewardedAd) {
        print(">>> YandexMobileAds \(#function)")
        
        self.videoLoadedCallback?()
        
        self.rewardedAd = rewardedAd
        self.rewardedAd?.delegate = self
    }

    func rewardedAdLoader(_ adLoader: RewardedAdLoader, didFailToLoadWithError error: AdRequestError) {
        print(">>> YandexMobileAds \(#function)")
        self.failLoadCallback?(error.error.localizedDescription)
    }
}

extension RewardedViewController: RewardedAdDelegate {
    func rewardedAd(_ rewardedAd: YandexMobileAds.RewardedAd, didReward reward: any YandexMobileAds.Reward) {
        print(">>> YandexMobileAds \(#function)")
        rewardedCallback?(reward.amount, reward.type)
    }
    
    func rewardedAd(_ rewardedAd: RewardedAd, didFailToShowWithError error: any Error) {
        print(">>> YandexMobileAds \(#function)")
        print(">>> YandexMobileAds error: \(error)")
        DispatchQueue.main.async {
            self.failLoadCallback?(error.localizedDescription)
            self.dismiss(animated: false)
        }
    }
    
    func rewardedAdDidShow(_ rewardedAd: RewardedAd) {
        print(">>> YandexMobileAds \(#function)")
    }
    
    func rewardedAdDidClick(_ rewardedAd: RewardedAd) {
        print(">>> YandexMobileAds \(#function)")
    }
    
    func rewardedAd(_ rewardedAd: RewardedAd, didTrackImpressionWith impressionData: (any ImpressionData)?) {
        print(">>> YandexMobileAds \(#function)")
    }
    
    func rewardedAdDidDismiss(_ rewardedAd: RewardedAd) {
        print(">>> YandexMobileAds \(#function)")
        DispatchQueue.main.async {
            self.closeCallback?()
            self.dismiss(animated: false)
        }
    }
}
