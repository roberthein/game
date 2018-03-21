import Foundation
import UIKit
import SceneKit
import Observable

enum PlayerState {
    case normal
    case gold
    case dead
    case finished
}

class PlayerNode: SCNNode {
    
    private lazy var material: SCNMaterial = {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.lightGray
        
        return material
    }()
    
    override init() {
        super.init()
        
        geometry = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
        geometry?.materials = [material]
        
        position.y = 0.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

