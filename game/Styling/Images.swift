import Foundation
import UIKit

public extension UIImage {
    
    public enum GameImage: String {
        case sky
        case sphere
    }
    
    public convenience init(gameImage: GameImage) {
        self.init(named: gameImage.rawValue)!
    }
}
