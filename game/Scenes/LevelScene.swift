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
    
    var walls: [WallNode] = [] { didSet { add(walls) } }
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
        
        add([floorNode, playerNode, cameraNode])
        
        buildLevel()
        bind()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildLevel() {
        remove(walls)
        walls = level.walls.map { WallNode(position: $0) }
        
        remove(lasers)
        lasers = level.lasers.map { LaserNode(laser: $0) }
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
