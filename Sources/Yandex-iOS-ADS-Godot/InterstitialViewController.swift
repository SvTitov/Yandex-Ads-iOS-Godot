import Foundation
import YandexMobileAds

class InterstitialViewController: UIViewController {
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
        interstitialAd?.show(from: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAd()
    }
}

extension InterstitialViewController: InterstitialAdLoaderDelegate {
    func interstitialAdLoader(_ adLoader: InterstitialAdLoader, didLoad interstitialAd: InterstitialAd) {
        print(">>> YandexMobileAds \(#function)")
        
        self.interstitialAd = interstitialAd
        self.interstitialAd?.delegate = self
        
        showAd()
    }

    func interstitialAdLoader(_ adLoader: InterstitialAdLoader, didFailToLoadWithError error: AdRequestError) {
        print(">>> YandexMobileAds \(#function)")
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
        self.dismiss(animated: false)
    }
    
    func interstitialAd(_ interstitialAd: InterstitialAd, didTrackImpressionWith impressionData: (any ImpressionData)?) {
        print(">>> YandexMobileAds \(#function)")
    }
    
    func interstitialAdDidDismiss(_ interstitialAd: InterstitialAd) {
        print(">>> YandexMobileAds \(#function)")
        self.dismiss(animated: false)
    }
}
