import Foundation
import SceneKit
import Extras

public enum Particles: String {
    case beams
    case sparkles
    case sparklesBig
    case impact
    
    var system: SCNParticleSystem {
        guard let particles = SCNParticleSystem(named: "\(rawValue)", inDirectory: "art.scnassets/") else {
            fatalError("Failed to load particle system.")
        }
        
        return particles
    }
    
    func node(color: UIColor = .gold) -> SCNNode {
        let particleSystem = system
        particleSystem.blendMode = .additive
        particleSystem.particleColor = color
        
        let particleSystemNode = SCNNode()
        particleSystemNode.addParticleSystem(particleSystem)
        particleSystemNode.position = .zero
        
        return particleSystemNode
    }
}
