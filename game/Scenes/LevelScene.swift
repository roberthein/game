import UIKit
import SceneKit
import Ease
import Observable
import Extras

class LevelScene: SCNScene {
    
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
}
