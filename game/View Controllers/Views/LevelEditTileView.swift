import UIKit
import SceneKit

enum TileType: String {
    case none
    case start
    case end
    case wall
    case coin
    case sphere
    case laser
    
    var color: UIColor {
        switch self {
        case .none: return .gray
        case .start: return .cyan
        case .end: return .purple
        case .wall: return .red
        case .coin: return .yellow
        case .sphere: return .green
        case .laser: return .orange
        }
    }
}

class LevelEditTileView: UIView {
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let gestureRecognizer = UITapGestureRecognizer()
        gestureRecognizer.cancelsTouchesInView = false
        
        return gestureRecognizer
    }()
    
    private lazy var label: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 8)
        view.textColor = .black
        view.textAlignment = .center
        
        return view
    }()
    
    private(set) var type: TileType
    let position: Float2
    
    required init(type: TileType, position: Float2) {
        self.type = type
        self.position = position
        super.init(frame: .zero)
        
        setTileType(type)
        
        addSubview(label)
        label.text = "\(Int(position.x)), \(Int(position.z))"
        
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
    
    func setTileType(_ type: TileType) {
        self.type = type
        backgroundColor = type.color
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
