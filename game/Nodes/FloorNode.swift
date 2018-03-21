import Foundation
import SceneKit
import Extras

class FloorNode: SCNNode {
    
    private lazy var material: SCNMaterial = {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.black
        
        return material
    }()
    
    private lazy var floorGeometry: SCNGeometry = {
        let geometry = SCNFloor()
        geometry.materials = [material]
        
        return geometry
    }()
    
    override init() {
        super.init()
        
        geometry = floorGeometry
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
