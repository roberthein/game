import Foundation
import UIKit
import SceneKit

class PortalNode: SCNNode {
    
    private lazy var material: SCNMaterial = {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.purple
        
        return material
    }()
    
    override init() {
        super.init()
        name = "portal"
        
        geometry = SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0)
        geometry?.materials = [material]
        
        physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0)))
        physicsBody?.contactTestBitMask = 999
        
        runAction(.repeatForever(.rotateBy(x: 0, y: CGFloat.pi * 2, z: 0, duration: 20)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
