import Foundation
import SceneKit
import Extras

class FloorNode: SCNNode {
    
    private lazy var material: SCNMaterial = {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.backgroundColor
        
        return material
    }()
    
    private lazy var floorGeometry: SCNGeometry = {
        let geometry = SCNFloor()
        geometry.reflectivity = 0.3
        geometry.reflectionFalloffStart = 0
        geometry.reflectionFalloffEnd = 1
        geometry.materials = [material]
        
        return geometry
    }()
    
    override init() {
        super.init()
        
        physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: floorGeometry))
        physicsBody?.collisionBitMask = 888
        physicsBody?.categoryBitMask = 777
        geometry = floorGeometry
        position = .zero
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
