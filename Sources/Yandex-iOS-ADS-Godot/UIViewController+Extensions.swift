import Foundation
import UIKit

extension UIViewController {
    static var topViewController: UIViewController? {
         guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = windowScene.windows.first?.rootViewController else {
             return nil
         }

         return rootViewController
    }
}
