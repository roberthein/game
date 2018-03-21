import Foundation
import UIKit
import SceneKit

class PaprikaExplosionNode: SCNNode {
    
    private lazy var nodes: [SCNNode] = {
        let childNodes = Models.paprikaExplosion.childNodes
            
        childNodes.forEach {
            guard let geometry = $0.geometry, let materials = materials else { return }
            geometry.materials = materials
            
            let x: CGFloat = CGFloat(direction.x) * (CGFloat(2 + arc4random_uniform(10)) / 5)
            let y: CGFloat = 0
            let z: CGFloat = CGFloat(direction.z) * (CGFloat(2 + arc4random_uniform(10)) / 5)
            
            $0.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: geometry))
            $0.physicsBody?.collisionBitMask = 888
            $0.physicsBody?.categoryBitMask = 777
            $0.physicsBody?.restitution = 0.1
            $0.physicsBody?.applyForce(SCNVector3(x, y, z), at: SCNVector3(0, 0, 0), asImpulse: true)
        }
        
        return childNodes
    }()
    
    let direction: Float2
    let materials: [SCNMaterial]?
    
    required init(direction: Float2, materials: [SCNMaterial]?) {
        self.direction = direction
        self.materials = materials
        super.init()
        
        nodes.forEach {
            addChildNode($0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
