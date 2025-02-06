import Foundation
import UIKit
import YandexMobileAds

class RewardedViewController: UIViewController {
    typealias Callback = (Int, String) -> Void

    private var callback: Callback?
    
    private lazy var rewardedAdLoader: RewardedAdLoader = {
        let loader = RewardedAdLoader()
        loader.delegate = self
        return loader
    }()
    
    private var adUnitID: String = ""
    
    func setAdUnitID(_ adUnitID: String) {
        self.adUnitID = adUnitID
    }
    
    func setRewardCallback(_ callback: @escaping Callback) {
        self.callback = callback
    }
    
    private var rewardedAd: RewardedAd?
    
    func loadAd() {
          let configuration = AdRequestConfiguration(adUnitID: adUnitID)
          rewardedAdLoader.loadAd(with: configuration)
    }
    
    func showAd() {
       rewardedAd?.show(from: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAd()
    }
}

extension RewardedViewController: RewardedAdLoaderDelegate {
    func rewardedAdLoader(_ adLoader: RewardedAdLoader, didLoad rewardedAd: RewardedAd) {
        print(">>> YandexMobileAds \(#function)")
        
        self.rewardedAd = rewardedAd
        self.rewardedAd?.delegate = self

        showAd()
    }

    func rewardedAdLoader(_ adLoader: RewardedAdLoader, didFailToLoadWithError error: AdRequestError) {
        print(">>> YandexMobileAds \(#function)")
    }
}

extension RewardedViewController: RewardedAdDelegate {
    func rewardedAd(_ rewardedAd: YandexMobileAds.RewardedAd, didReward reward: any YandexMobileAds.Reward) {
        print(">>> YandexMobileAds \(#function)")
        callback?(reward.amount, reward.type)
    }
    
    func rewardedAd(_ rewardedAd: RewardedAd, didFailToShowWithError error: any Error) {
        print(">>> YandexMobileAds \(#function)")
        print(">>> YandexMobileAds error: \(error)")
        self.dismiss(animated: false)
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
        self.dismiss(animated: false)
    }
}
