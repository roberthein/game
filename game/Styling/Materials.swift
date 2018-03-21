import Foundation
import SceneKit

extension SCNMaterial {
    
    class var goldMaterial: SCNMaterial {
        let material = SCNMaterial()
        material.lightingModel = .physicallyBased
        material.diffuse.contents = UIColor.gold
        material.emission.contents = UIColor.gold
        material.emission.intensity = 0.1
        material.metalness.contents = UIColor.white
        
        return material
    }
}
