import Foundation
import SceneKit

extension SCNMaterial {
    
    class var playerMaterial: SCNMaterial {
        let material = SCNMaterial()
        material.lightingModel = .physicallyBased
        material.diffuse.contents = UIColor.turquoise
        
        return material
    }
    
    class var goldMaterial: SCNMaterial {
        let material = SCNMaterial()
        material.lightingModel = .physicallyBased
        material.diffuse.contents = UIColor.gold
        material.emission.contents = UIColor.gold
        material.emission.intensity = 0.1
        material.metalness.contents = UIColor.white
        
        return material
    }
    
    class var crystalMaterial: SCNMaterial {
        let material = SCNMaterial()
        material.isDoubleSided = true
        material.lightingModel = .physicallyBased
        material.diffuse.contents = UIImage(gameImage: .sphere)
        material.emission.contents = UIImage(gameImage: .sphere)
        material.emission.intensity = 0.1
        material.metalness.contents = UIColor.white
        material.metalness.intensity = 2
        material.blendMode = .add
        
        return material
    }
    
    class var portalMaterial: SCNMaterial {
        let material = SCNMaterial()
        material.isDoubleSided = true
        material.lightingModel = .physicallyBased
        material.diffuse.contents = UIColor.gold.withAlphaComponent(0.7)
        material.metalness.contents = UIColor.white
        material.metalness.intensity = 1
        material.blendMode = .add
        
        return material
    }
    
    class var laserMaterial: SCNMaterial {
        let material = SCNMaterial()
        material.isDoubleSided = true
        material.lightingModel = .physicallyBased
        material.diffuse.contents = UIColor.turquoise
        material.emission.contents = UIColor.turquoise
        material.emission.intensity = 1
        material.metalness.contents = UIColor.white
        material.metalness.intensity = 5
        material.blendMode = .add
        
        return material
    }
    
    class var blackMaterial: SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.black
        
        return material
    }
}

