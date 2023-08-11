import UIKit

enum AppFont: String {
    case robotoRegular = "Roboto-Regular"
    case robotoBold = "Roboto-Bold"
    case robotoMedium = "Roboto-Medium"

    func withSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
