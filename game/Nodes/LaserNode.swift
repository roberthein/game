import Foundation
import UIKit
import SceneKit

class LaserBeam: SCNNode {}

class LaserNode: SCNNode {
    
    private lazy var material: SCNMaterial = {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.orange
        
        return material
    }()
    
    private(set) lazy var beam: LaserBeam = {
        let radius: CGFloat = 0.3 / 2
        let length = CGFloat(laser.vector.x.isZero ? abs(laser.vector.z) : abs(laser.vector.x))
        let angle: Float = laser.vector.x < 0 || laser.vector.z < 0 ? Float.pi : -Float.pi
        let direction: Float2 = Float2(laser.vector.x.isZero ? 0 : 1, laser.vector.z.isZero ? 0 : 1)
        
        let laserGeometry = SCNCylinder(radius: 0.025, height: length)
        
        let node = LaserBeam()
        node.geometry = laserGeometry
        node.geometry?.materials = [material]
        node.pivot = SCNMatrix4MakeTranslation(0, Float(length) / 2, 0)
        node.rotation = SCNVector4(1, 0, 0, angle / 2)
        
        if !direction.x.isZero {
            node.transform = SCNMatrix4Mult(node.transform, SCNMatrix4MakeRotation(Float.pi / 2, 0, 1, 0))
        }
        
        node.position = SCNVector3(laser.startPosition.x, 0.4, laser.startPosition.z)
        
        return node
    }()
    
    let laser: Laser
    
    required init(laser: Laser) {
        self.laser = laser
        super.init()
        
        precondition(laser.vector.x.isZero || laser.vector.z.isZero)
        precondition(laser.vector.x != laser.vector.z)
        
        addChildNode(beam)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}