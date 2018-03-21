import UIKit
import SceneKit
import Ease
import Observable
import Extras

class LevelScene: SCNScene {
    
    private(set) lazy var cameraNode = CameraNode()
    private(set) lazy var floorNode = FloorNode()
    private(set) lazy var playerNode = PlayerNode()
    
    var level: Level
    
    required init(level: Level) {
        self.level = level
        super.init()
        
        background.contents = UIColor.darkGray
        
        add([floorNode, playerNode, cameraNode])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
