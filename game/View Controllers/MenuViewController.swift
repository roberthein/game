import UIKit
import TinyConstraints

enum LevelType: String {
    case level0
    case level1
    case level2
    case level3
    case level4
    case level5
    case level6
    
    var levelIndex: Int? {
        switch self {
        case .level0: return 0
        case .level1: return 1
        case .level2: return 2
        case .level3: return 3
        case .level4: return 4
        case .level5: return 5
        case .level6: return 6
        }
    }
}

class MenuViewController: UIViewController {
    
    private lazy var typeControl: UISegmentedControl = {
        let types: [LevelType] = [.level0, .level1, .level2, .level3, .level4, .level5, .level6]
        let items = types.map { $0.rawValue }
        
        let view = UISegmentedControl(items: items)
        view.backgroundColor = .white
        view.addTarget(self, action: #selector(push(_:)), for: .valueChanged)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(typeControl)
        typeControl.centerXToSuperview()
        typeControl.bottomToSuperview(offset: -50, usingSafeArea: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc func push(_ segmentedControl: UISegmentedControl) {
        
        let level = App.game.level(for: GameIndex(world: 0, level: segmentedControl.selectedSegmentIndex))
        let levelViewController = LevelViewController(level: level)
        
        navigationController?.pushViewController(levelViewController, animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return true
    }
}
