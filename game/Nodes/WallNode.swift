import Foundation
import UIKit
import SceneKit
import Extras

class WallNode: SCNNode {
    
    private lazy var material: SCNMaterial = {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        
        return material
    }()
    
    required init(position: Float2) {
        super.init()
        self.position = SCNVector3(position.x, 0, position.z)
        
        geometry = SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0)
        geometry?.materials = [material]
        
        physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: SCNSphere(radius: 0.5 / 2)))
        physicsBody?.contactTestBitMask = 999
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

