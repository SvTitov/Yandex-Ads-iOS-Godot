import Foundation
import YandexMobileAds

class InterstitialViewController: UIViewController {
    
    var loaded_callback : (() -> Void)? = nil
    var fail_callback   : ((String) -> Void)? = nil
    var close_callback  : (() -> Void)? = nil
    
    private lazy var interstitialAdLoader: InterstitialAdLoader = {
        let loader = InterstitialAdLoader()
        loader.delegate = self
        return loader
    }()
    
    private var interstitialAd: InterstitialAd?
    private var adUnitID: String = ""
    
    func setAdUnitID(_ adUnitID: String) {
        self.adUnitID = adUnitID
    }
    
    func loadAd() {
        let configuration = AdRequestConfiguration(adUnitID: adUnitID)
        interstitialAdLoader.loadAd(with: configuration)
    }
    
    func showAd() {
        DispatchQueue.main.async {
            self.interstitialAd?.show(from: self)
        }
    }
    
    func setLoadedCallback(_ callback: @escaping () -> Void) {
        self.loaded_callback = callback
    }
    
    func setFailCallback(_ callback: @escaping (String) -> Void) {
        self.fail_callback = callback
    }
    
    func setCloseCallback(_ callback: @escaping () -> Void) {
        self.close_callback = callback
    }
}

extension InterstitialViewController: InterstitialAdLoaderDelegate {
    func interstitialAdLoader(_ adLoader: InterstitialAdLoader, didLoad interstitialAd: InterstitialAd) {
        print(">>> YandexMobileAds \(#function)")
        
        self.loaded_callback?()
        
        self.interstitialAd = interstitialAd
        self.interstitialAd?.delegate = self
    }

    func interstitialAdLoader(_ adLoader: InterstitialAdLoader, didFailToLoadWithError error: AdRequestError) {
        print(">>> YandexMobileAds \(#function)")
        self.fail_callback?(error.error.localizedDescription)
    }
}

extension InterstitialViewController: InterstitialAdDelegate {
    func interstitialAdDidShow(_ interstitialAd: InterstitialAd) {
        print(">>> YandexMobileAds \(#function)")
    }
    
    func interstitialAdDidClick(_ interstitialAd: InterstitialAd) {
        print(">>> YandexMobileAds \(#function)")
    }
    
    func interstitialAd(_ interstitialAd: InterstitialAd, didFailToShowWithError error: any Error) {
        print(">>> YandexMobileAds \(#function)")
        print(">>> YandexMobileAds error: \(error)")
        DispatchQueue.main.async {
            self.dismiss(animated: false)
        }
    }
    
    func interstitialAd(_ interstitialAd: InterstitialAd, didTrackImpressionWith impressionData: (any ImpressionData)?) {
        print(">>> YandexMobileAds \(#function)")
    }
    
    func interstitialAdDidDismiss(_ interstitialAd: InterstitialAd) {
        print(">>> YandexMobileAds \(#function)")
        DispatchQueue.main.async {
            self.dismiss(animated: false)
            self.close_callback?()
        }
    }
}
