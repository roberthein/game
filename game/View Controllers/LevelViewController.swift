import UIKit
import TinyConstraints
import SceneKit

class LevelViewController: UIViewController {
    
    private lazy var backButton: UIButton = {
        let view = UIButton()
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        view.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        
        return view
    }()
    
    private lazy var levelScene = LevelScene(level: level)
    
    private lazy var scnView: SCNView = {
        let view = SCNView(frame: UIScreen.main.bounds)
        view.antialiasingMode = .multisampling4X
        view.scene = levelScene
        view.autoenablesDefaultLighting = true
        
        return view
    }()
    
    var level: Level {
        didSet {
            levelScene.level = level
        }
    }
    
    required init(level: Level) {
        self.level = level
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        
        view.addSubview(scnView)
        view.addSubview(backButton)
        
        backButton.topToSuperview(offset: 20, usingSafeArea: true)
        backButton.leftToSuperview(offset: 20)
        backButton.size(CGSize(width: 44, height: 44))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc func back(_ buttone: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return true
    }
}