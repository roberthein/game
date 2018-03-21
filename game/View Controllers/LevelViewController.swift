import UIKit
import SceneKit
import TinyConstraints
import Observable

class LevelViewController: UIViewController {
    
    private var disposal = Disposal()
    private lazy var controller = iOSController()
    
    private lazy var coinCountLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "ArialRoundedMTBold", size: 50)
        view.textColor = UIColor.turquoise.withAlphaComponent(0.5)
        
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let view = UIButton()
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2 / UIScreen.main.scale
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        view.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        
        return view
    }()
    
    private lazy var editButton: UIButton = {
        let view = UIButton()
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2 / UIScreen.main.scale
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        view.addTarget(self, action: #selector(edit(_:)), for: .touchUpInside)
        
        return view
    }()
    
    private lazy var levelScene = LevelScene(level: level)
    
    private lazy var scnView: SCNView = {
        let view = SCNView(frame: UIScreen.main.bounds)
        view.antialiasingMode = .multisampling4X
        view.scene = levelScene
        
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
        
        view.backgroundColor = UIColor.backgroundColor
        view.addGestureRecognizer(controller.panGestureRecognizer)
        
        view.addSubview(scnView)
        view.addSubview(backButton)
        view.addSubview(editButton)
        view.addSubview(coinCountLabel)
        
        backButton.topToSuperview(offset: 20, usingSafeArea: true)
        backButton.leftToSuperview(offset: 20)
        backButton.size(CGSize(width: 44, height: 44))
        
        editButton.topToSuperview(offset: 20, usingSafeArea: true)
        editButton.rightToSuperview(offset: 20)
        editButton.size(CGSize(width: 44, height: 44))
        
        coinCountLabel.centerXToSuperview()
        coinCountLabel.topToSuperview(offset: 20, usingSafeArea: true)
        
        controller.currentRotation.observe { [weak self] rotation, previousRotation in
            self?.levelScene.playerNode.currentRotation.value = rotation
            }.add(to: &disposal)
        
        levelScene.playerNode.state.observe { [weak self] state, previousState in
            guard let _self = self, let previousState = previousState else { return }
            
            if state == .finished, previousState != .finished {
                _self.controller.isEnabled = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                    _self.navigationController?.fadePop()
                })
            }
            
            }.add(to: &disposal)
        
        levelScene.coinCount.observe { [weak self] count, previousCount in
            guard let _self = self else { return }
            _self.coinCountLabel.text = "\(count)" + "/" + "\(_self.level.coins.count)"
            }.add(to: &disposal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc func back(_ buttone: UIButton) {
        navigationController?.fadePop()
    }
    
    @objc func edit(_ buttone: UIButton) {
        let levelEditViewController = LevelEditViewController(with: level)
        levelEditViewController.delegate = self
        present(levelEditViewController, animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return true
    }
}

extension LevelViewController: LevelEditViewControllerDelegate {
    
    func didEdit(level: Level) {
        self.level = level
        App.game.saveLevel(level)
    }
}
