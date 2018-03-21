import Foundation
import UIKit
import SceneKit
import Extras

public enum Models: String {
    case paprika
    case paprikaExplosion
    case sphere
    case wall
    case coin
    case turret
    
    var scene: SCNScene {
        let fileName: String = rawValue
        guard let scene = SCNScene(named: fileName + ".dae") else {
            fatalError("Failed to load Scene.")
        }
        
        return scene
    }
    
    var childNodes: [SCNNode] {
        let fileName: String = rawValue
        guard let scene = SCNScene(named: fileName + ".dae") else {
            fatalError("Failed to load child nodes.")
        }
        
        return scene.rootNode.childNodes
    }
    
    var geometry: SCNGeometry {
        let fileName: String = rawValue
        guard let scene = SCNScene(named: fileName + ".dae"), let geometry = scene.rootNode.childNodes[safe: 0]?.geometry else {
            fatalError("Failed to load geometry.")
        }
        
        return geometry
    }
}
