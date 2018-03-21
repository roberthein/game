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
    
    let state = Observable(PlayerState.normal)
    
    var disposal = Disposal()
    
    let currentRotation = Observable(Float2.zero)
    let targetPosition = Observable(Float2.zero)
    let newPosition = Observable(Float2.zero)
    
    let radius: Float = 0.5
    let rotationDuration = 0.2
    var isRotating = false
    var pendingRotation: Float2?
    
    private(set) lazy var container: SCNNode = {
        let node = SCNNode()
        node.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        node.geometry = Models.paprika.geometry
        
        return node
    }()
    
    let playerMaterial: SCNMaterial = .playerMaterial
    let goldPlayerMaterial: SCNMaterial = .goldMaterial
    
    override init() {
        super.init()
        
        physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)))
        physicsBody?.contactTestBitMask = 999
        
        addChildNode(container)
        
        currentRotation.observe { [weak self] rotation, oldValue in
            self?.rotate(rotation: rotation)
            }.add(to: &disposal)
        
        state.observe { [weak self] state, previousState in
            guard let _self = self, state != previousState else { return }
            
            switch state {
            case .normal:
                _self.container.geometry?.materials = [_self.playerMaterial]
            case .gold:
                _self.container.geometry?.materials = [_self.goldPlayerMaterial]
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                    _self.state.value = .normal
                })
            case .dead:
                print("dead")
            case .finished:
                print("finished")
            }
            }.add(to: &disposal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func forceNewPosition(_ forcedNewPosition: Float2) {
        position = SCNVector3(forcedNewPosition.x, 0, forcedNewPosition.z)
        targetPosition.value = forcedNewPosition
        newPosition.value = forcedNewPosition
    }
    
    func rotate(rotation: Float2) {
        guard !rotation.isZero else {
            finalise(rotation)
            return
        }
        
        guard state.value != .dead, state.value != .finished else {
            return
        }
        
        if isRotating {
            pendingRotation = rotation
        } else {
            isRotating = true
            
            pivot = SCNMatrix4MakeTranslation(radius * rotation.x, -radius, radius * rotation.z)
            position = SCNVector3(position.x + (radius * rotation.x), 0, position.z + (radius * rotation.z))
            
            targetPosition.value = Float2(targetPosition.value.x + rotation.x, targetPosition.value.z + rotation.z)
            
            let angle: CGFloat
            let axis: SCNVector3
            
            if !rotation.x.isZero {
                angle = -(CGFloat.pi / 2) * CGFloat(rotation.x)
                axis = SCNVector3(x: 0, y: 0, z: 1)
            } else {
                angle = (CGFloat.pi / 2) * CGFloat(rotation.z)
                axis = SCNVector3(x: 1, y: 0, z: 0)
            }
            
            runAction(.rotate(by: angle, around: axis, duration: rotationDuration), completionHandler:{ [weak self] in
                self?.finalise(rotation)
            })
        }
    }
    
    func finalise(_ r: Float2) {
        isRotating = false
        
        position = SCNVector3(position.x + (radius * r.x), 0, position.z + (radius * r.z))
        rotation = SCNVector4(0, 0, 0, 0)
        pivot = SCNMatrix4MakeTranslation(0, -0.5, 0)
        
        container.transform = SCNMatrix4Mult(container.transform, r.x.isZero ? SCNMatrix4MakeRotation((Float.pi / 2) * r.z, 1, 0, 0) : SCNMatrix4MakeRotation((-Float.pi / 2) * r.x, 0, 0, 1))
        newPosition.value = Float2(position.x, position.z)
        
        if let pendingRotation = pendingRotation {
            rotate(rotation: pendingRotation)
            self.pendingRotation = nil
        }
    }
}

