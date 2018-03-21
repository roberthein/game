import Foundation
import UIKit
import SceneKit

class TurretNode: SCNNode {
    
    override init() {
        super.init()
        
        geometry = Models.turret.geometry
        geometry?.materials = [.blackMaterial]
        
        if let geometry = geometry {
            physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: geometry))
            physicsBody?.collisionBitMask = 888
            physicsBody?.categoryBitMask = 777
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
