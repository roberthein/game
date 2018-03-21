import Foundation
import UIKit
import SceneKit
import Observable

enum PanGestureDirection {
    case topRight
    case bottomLeft
    case topLeft
    case bottomRight
}

class iOSController {

    var panGestureDirection: PanGestureDirection?
    var currentRotation = Observable(Float2.zero)
    
    private(set) lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        
        return gestureRecognizer
    }()
    
    var isEnabled = true {
        didSet {
            panGestureRecognizer.view?.gestureRecognizers?.forEach { $0.isEnabled = isEnabled }
        }
    }
    
    @objc func pan(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        switch panGestureRecognizer.state {
        case .changed:
            if panGestureDirection == nil {
                let translation = panGestureRecognizer.translation(in: panGestureRecognizer.view)
                panning(translation: translation, threshold: 20)
            }
        case .ended, .cancelled, .failed:
            panGestureDirection = nil
        default:
            break
        }
    }
    
    func panning(translation: CGPoint, threshold: CGFloat) {
        
        if translation.x > threshold {
            
            if translation.y > threshold {
                panGestureDirection = .bottomRight
            } else if translation.y < -threshold {
                panGestureDirection = .topRight
            }
            
        } else if translation.x < -threshold {
            
            if translation.y > threshold {
                panGestureDirection = .bottomLeft
            } else if translation.y < -threshold {
                panGestureDirection = .topLeft
            }
        }
        
        if let panGestureDirection = panGestureDirection {
            currentRotation.value = rotationFor(direction: panGestureDirection)
        }
    }
    
    func rotationFor(direction: PanGestureDirection) -> Float2 {
        
        switch direction {
        case .topRight:
            return Float2(1, 0)
        case .bottomLeft:
            return Float2(-1, 0)
        case .topLeft:
            return Float2(0, -1)
        case .bottomRight:
            return Float2(0, 1)
        }
    }
}
