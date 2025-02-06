import Foundation
import YandexMobileAds

final class StickyBannerViewController: UIViewController {
    
    var adView: AdView?
    
    func loadAd(_ adUnitID: String) {
        adView = createAdView(adUnitID)
        adView?.loadAd()
    }
    
    func createAdView(_ adUnitID: String) -> AdView {
        let width = view.safeAreaLayoutGuide.layoutFrame.width
        let adSize = BannerAdSize.stickySize(withContainerWidth: width)
        
        let adView = AdView(adUnitID: adUnitID, adSize: adSize)
        adView.translatesAutoresizingMaskIntoConstraints = false
        adView.delegate = self
        
        return adView
    }
    
    func showAd(viewController: UIViewController) {
        guard let adView = adView else {
            print(">>> YandexMobileAds \(#function) no adView initialized")
            return
        }
        
        viewController.view.addSubview(adView)
        NSLayoutConstraint.activate([
            adView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor),
            adView.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor)
        ])
    }
}

extension StickyBannerViewController: AdViewDelegate {
    func adViewDidLoad(_ adView: AdView) {
        print(">>> YandexMobileAds \(#function)")
    }
    
    func adViewDidFailLoading(_ adView: AdView, error: any Error) {
        print(">>> YandexMobileAds \(#function)")
    }
    
    func adViewDidClick(_ adView: AdView) {
        print(">>> YandexMobileAds \(#function)")
    }
    
    func adView(_ adView: AdView, didTrackImpression impressionData: (any ImpressionData)?) {
        print(">>> YandexMobileAds \(#function) \(impressionData?.rawData ?? " ")")
    }
    
    func adViewWillLeaveApplication(_ adView: AdView) {
        print(">>> YandexMobileAds \(#function)")
    }
    
    func adView(_ adView: AdView, willPresentScreen viewController: UIViewController?) {
        print(">>> YandexMobileAds \(#function)")
    }
    
    func adView(_ adView: AdView, didDismissScreen viewController: UIViewController?) {
        print(">>> YandexMobileAds \(#function)")
    }
}
