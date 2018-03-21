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
        
        background.contents = UIColor.darkGray
        physicsWorld.contactDelegate = self
        
        add([floorNode, playerNode, cameraNode, portalNode])
        
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
    }
}

extension LevelScene: SCNPhysicsContactDelegate {
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        contact.between(playerNode, and: walls) { [weak self] player, wall in
            self?.playerNode.state.value = .dead
        }
        
        contact.between(playerNode, and: lasers.flatMap { $0.beam }) { [weak self] player, laser in
            guard let _self = self else { return }
            if _self.playerNode.state.value == .normal {
                _self.playerNode.state.value = .dead
            }
        }
    }
}
