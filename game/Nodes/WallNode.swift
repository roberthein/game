import Foundation
import UIKit
import SceneKit
import Extras

class WallNode: SCNNode {
    
    var isOn: Bool = false {
        didSet {
            beamNode.isHidden = isOn ? false : true
        }
    }
    
    private lazy var beamNode: SCNNode = {
        let height: CGFloat = 10
        let laserGeometry = SCNTube(innerRadius: 0.15, outerRadius: 0.15, height: height)
        laserGeometry.heightSegmentCount = 1
        laserGeometry.radialSegmentCount = 6
        
        let node = LaserBeam()
        node.geometry = laserGeometry
        node.geometry?.materials = [.laserMaterial]
        node.pivot = SCNMatrix4MakeTranslation(0, -Float(height / 2), 0)
        node.isHidden = true
        
        return node
    }()
    
    required init(position: Float2) {
        super.init()
        self.position = SCNVector3(position.x, 0, position.z)
        
        geometry = Models.wall.geometry
        geometry?.materials = [.blackMaterial]
        
        addChildNode(beamNode)
        
        physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: SCNSphere(radius: 0.5 / 2)))
        physicsBody?.contactTestBitMask = 999
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

