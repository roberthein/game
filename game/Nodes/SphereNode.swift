import Foundation
import UIKit
import SceneKit

class SphereNode: SCNNode {
    
    private lazy var material: SCNMaterial = {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.white
        
        return material
    }()
    
    required init(position: Float2) {
        super.init()
        self.position = SCNVector3(position.x, 0.5, position.z)
        
        let diameter: Float = 0.6
        scale = SCNVector3(diameter, diameter, diameter)
        
        geometry = SCNSphere(radius: 0.2)
        geometry?.materials = [material]
        
        physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: SCNSphere(radius: CGFloat(diameter) / 4)))
        physicsBody?.contactTestBitMask = 999
        
        runAction(.repeatForever(.rotateBy(x: CGFloat.pi * 2, y: CGFloat.pi * 2, z: CGFloat.pi * 2, duration: 5)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}