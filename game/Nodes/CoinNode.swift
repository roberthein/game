import Foundation
import UIKit
import SceneKit
import Extras

class CoinNode: SCNNode {
    
    required init(position: Float2) {
        super.init()
        self.position = SCNVector3(position.x, 0.5, position.z)
        
        geometry = Models.coin.geometry
        geometry?.materials = [.goldMaterial]
        
        physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: SCNSphere(radius: 0.25)))
        physicsBody?.contactTestBitMask = 999
        
        animate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animate() {
        runAction(.repeatForever(.rotateBy(x: 0, y: CGFloat.pi * 2, z: 0, duration: 3)))
    }
    
    func animateCollected() {
        position.y += 1
        rotation = .zero
        removeAllActions()
        runAction(.repeatForever(.rotateBy(x: 0, y: CGFloat.pi * 2, z: 0, duration: 0.3)))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: { [weak self] in
            self?.runAction(.scale(to: 0, duration: 0.1), completionHandler: {
                self?.removeAllActions()
                self?.isHidden = true
            })
        })
    }
    
    func reset() {
        removeAllActions()
        scale = SCNVector3(1, 1, 1)
        position.y = 0.5
        isHidden = false
        animate()
    }
}

