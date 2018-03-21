import Foundation
import SceneKit

class CameraNode: SCNNode {
    
    let distance: Float = 5
    let height: Float = 10
    
    private lazy var scnCamera: SCNCamera = {
        return SCNCamera()
    }()
    
    private lazy var container: SCNNode = {
        let node = SCNNode()
        node.camera = scnCamera
        node.transform = SCNMatrix4Mult(SCNMatrix4MakeRotation(-Float.pi / 4, 1, 0, 0), SCNMatrix4MakeRotation(-Float.pi / 4, 0, 1, 0))
        
        return node
    }()
    
    override init() {
        super.init()
        
        position = SCNVector3(x: -distance, y: height, z: distance)
        addChildNode(container)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}