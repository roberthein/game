import UIKit
import SceneKit
import TinyConstraints
import Ease
import Extras

enum MenuType {
    case title
    case levelSelect
}

enum ActionableItems: String {
    case playButton
    case level0
    case level1
    case level2
    case level3
    case level4
    case level5
    case level6
    case bonus
    
    var levelIndex: Int? {
        switch self {
        case .playButton: return nil
        case .level0: return 0
        case .level1: return 1
        case .level2: return 2
        case .level3: return 3
        case .level4: return 4
        case .level5: return 5
        case .level6: return 6
        case .bonus: return 7
        }
    }
}

class MenuViewController: UIViewController {
    
    private var disposal = EaseDisposal()
    private var ease: Ease<CGVector> = Ease(initialValue: CGVector.zero)
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
    
    private let gyroscope = GyroManager()
    
    private lazy var backButton: UIButton = {
        let view = UIButton()
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2 / UIScreen.main.scale
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        view.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        
        return view
    }()
    
    private lazy var scene: SCNScene = {
        let scene = type == .title ? Models.title.scene : Models.levelSelect.scene
        scene.background.contents = UIColor.backgroundColor
        scene.lightingEnvironment.contents =  UIImage(gameImage: .sky)
        scene.lightingEnvironment.intensity = 1.3
        scene.fogColor = UIColor.backgroundColor
        scene.fogStartDistance = 35
        scene.fogEndDistance = 45
        scene.fogDensityExponent = 2
        
        for (i, node) in scene.rootNode.childNodes.enumerated() {
            if let lastNode = scene.rootNode.childNodes.last, node == lastNode {
                node.geometry?.materials = [.goldTitleMaterial]
            } else {
                node.geometry?.materials = [.titleMaterial]
            }
            
            addSpring(for: node, at: CGFloat(i))
        }
        
        scene.rootNode.addChildNode(cameraNode)
        scene.rootNode.runAction(.repeatForever(.moveBy(x: 0, y: 0, z: 0, duration: 100)))
        
        return scene
    }()
    
    func addSpring(for node: SCNNode, at index: CGFloat) {
        ease.addSpring(tension: 50 - (index * 2), damping: 15 - index, mass: 4 - (index / 3)) { point in
            let xAngle: CGFloat = (-point.dy - 100) / 200
            let yAngle: CGFloat = -point.dx / 200
            node.transform = SCNMatrix4Mult(SCNMatrix4MakeTranslation(0, Float(point.dy / 50) + 2, 0), SCNMatrix4Mult(SCNMatrix4MakeRotation(Float(xAngle), 1, 0, 0), SCNMatrix4MakeRotation(Float(yAngle), 0, 1, 0)))
            }.add(to: &disposal)
    }
    
    private lazy var cameraNode: SCNNode = {
        let node = SCNNode()
        node.camera = SCNCamera()
        node.camera?.bloomIntensity = 1.5
        node.camera?.bloomBlurRadius = 5
        node.camera?.bloomThreshold = 0.2
        node.camera?.wantsHDR = true
        node.camera?.wantsExposureAdaptation = false
        node.position = SCNVector3(x: 0, y: 0, z: 35)
        
        return node
    }()
    
    let type: MenuType
    
    required init(type: MenuType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = SCNView()
    }
    
    private var scnView: SCNView? {
        return view as? SCNView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .brightBlue
        
        scnView?.scene = scene
        scnView?.backgroundColor = .brightBlue
        scnView?.antialiasingMode = .multisampling4X
        scnView?.addGestureRecognizer(tapGestureRecognizer)
        
        if type == .levelSelect {
            view.addSubview(backButton)
            
            backButton.topToSuperview(offset: 20, usingSafeArea: true)
            backButton.leftToSuperview(offset: 20)
            backButton.size(CGSize(width: 44, height: 44))
        }
        
        gyroscope.observe { [weak self] vector in
            self?.ease.targetValue = vector
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc func tap(_ gestureRecognize: UIGestureRecognizer) {
        guard let scnView = scnView else { return }
        
        if let hitResult = scnView.hitTest(gestureRecognize.location(in: scnView), options: [:]).first {
            if let name = hitResult.node.name, let item = ActionableItems(rawValue: name) {
                switch item {
                case .playButton:
                    navigationController?.fadePush(to: MenuViewController(type: .levelSelect))
                default:
                    if let levelIndex = item.levelIndex {
                        navigationController?.fadePush(to: LevelViewController(level: App.game.level(for: GameIndex(world: 0, level: levelIndex))))
                    }
                }
            }
        }
    }
    
    @objc func back(_ buttone: UIButton) {
        navigationController?.fadePop()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return true
    }
}

public extension UINavigationController {
    
    public func fadePush(to viewController: UIViewController) {
        pushViewController(viewController, animated: false)
    }
    
    public func fadePop() {
        popViewController(animated: false)
    }
}
