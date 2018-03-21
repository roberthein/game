import Foundation
import UIKit

extension UIColor {
    
    static func rgba(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
    class var turquoise: UIColor {
        return .rgba(50, 255, 255)
    }
    
    class var gold: UIColor {
        return .rgba(255, 210, 0)
    }
    
    class var brightBlue: UIColor {
        return .rgba(50, 0, 255)
    }
}

extension UIColor {
    
    class var backgroundColor: UIColor {
        return .brightBlue
    }
}
