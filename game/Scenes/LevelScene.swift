import UIKit
import SceneKit
import Ease
import Observable
import Extras

class LevelScene: SCNScene {
    
    private var disposal = Disposal()
    private var animationDisposal = EaseDisposal()
    private lazy var cameraPosition = Ease(initialValue: SCNVector3(level.start.x - cameraNode.distance, cameraNode.height, level.start.z + cameraNode.distance))
    
    private(set) lazy var cameraNode = CameraNode()
    private(set) lazy var floorNode = FloorNode()
    private(set) lazy var playerNode = PlayerNode()
    private(set) lazy var portalNode = PortalNode()
    
    let coinCount = Observable(Int.zero)
    
    var walls: [WallNode] = [] { didSet { add(walls) } }
    var coins: [CoinNode] = [] { didSet { add(coins) } }
    var spheres: [SphereNode] = [] { didSet { add(spheres) } }
    var lasers: [LaserNode] = [] { didSet { add(lasers) } }
    
    var level: Level {
        didSet {
            buildLevel()
        }
    }
    
    required init(level: Level) {
        self.level = level
        super.init()
        
        background.contents = UIColor.backgroundColor
        lightingEnvironment.contents =  UIImage(gameImage: .sky)
        lightingEnvironment.intensity = 1.3
        
        fogColor = UIColor.backgroundColor
        fogStartDistance = 12
        fogEndDistance = 17
        fogDensityExponent = 1
        
        rootNode.runAction(.repeatForever(.moveBy(x: 0, y: 0, z: 0, duration: 100)))
        
        physicsWorld.contactDelegate = self
        physicsWorld.timeStep = 1/200
        
        add([cameraNode, floorNode, playerNode, portalNode])
        buildLevel()
        bind()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildLevel() {
        remove(walls)
        walls = level.walls.map { WallNode(position: $0) }
        
        remove(coins)
        coins = level.coins.map { CoinNode(position: $0) }
        
        remove(spheres)
        spheres = level.spheres.map { SphereNode(position: $0) }
        
        remove(lasers)
        lasers = level.lasers.map { LaserNode(laser: $0) }
        
        playerNode.forceNewPosition(level.start)
        cameraNode.forceNewPosition(level.start)
        portalNode.position = SCNVector3(level.end.x, 0.85, level.end.z)
    }
    
    private func bind() {
        cameraPosition.addSpring(tension: 200, damping: 100, mass: 10) { [weak self] position in
            guard let _self = self else { return }
            _self.cameraNode.position = position
            }.add(to: &animationDisposal)
        
        playerNode.targetPosition.observe { [weak self] position, oldValue in
            guard let _self = self else { return }
            _self.cameraPosition.targetValue = SCNVector3(position.x - _self.cameraNode.distance, _self.cameraNode.height, position.z + _self.cameraNode.distance)
            }.add(to: &disposal)
        
        playerNode.newPosition.observe { [weak self] position, oldValue in
            guard let _self = self else { return }
            
            let impactNode = Particles.impact.node(color: _self.playerNode.state.value == .normal ? .turquoise : .gold)
            impactNode.position = SCNVector3(position.x, 0, position.z)
            impactNode.eulerAngles = SCNVector3(x: -Float.pi / 2, y: 0, z: 0)
            _self.rootNode.addChildNode(impactNode)
            }.add(to: &disposal)
        
        playerNode.state.observe { [weak self] state, previousState in
            guard let _self = self, let previousState = previousState else { return }
            
            if state == .normal, previousState == .dead {
                _self.coinCount.value = 0
                _self.walls.forEach { $0.isOn = false }
                _self.coins.forEach { $0.reset() }
                _self.playerNode.forceNewPosition(_self.level.start)
            } else if state == .finished, previousState != .finished {
                _self.portalNode.removeAllActions()
                _self.portalNode.runAction(.repeatForever(.moveBy(x: 0, y: 1, z: 0, duration: 1)))
                _self.portalNode.runAction(.repeatForever(.rotateBy(x: 0, y: CGFloat.pi * 2, z: 0, duration: 1)))
            }
            
            }.add(to: &disposal)
    }
}

extension LevelScene: SCNPhysicsContactDelegate {
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        contact.between(playerNode, and: walls) { [weak self] player, wall in
            wall.isOn = true
            self?.playerNode.state.value = .dead
        }
        
        contact.between(playerNode, and: coins) { [weak self] player, coin in
            coin.animateCollected()
            self?.coinCount.value += 1
        }
        
        contact.between(playerNode, and: spheres) { [weak self] player, sphere in
            self?.playerNode.state.value = .gold
        }
        
        contact.between(playerNode, and: lasers.flatMap { $0.beam }) { [weak self] player, laser in
            guard let _self = self else { return }
            if _self.playerNode.state.value == .normal {
                _self.playerNode.state.value = .dead
            }
        }
        
        let portalNodes: [PortalNode] = [portalNode]
        
        contact.between(playerNode, and: portalNodes) { [weak self] player, portal in
            self?.playerNode.state.value = .finished
        }
    }
}


