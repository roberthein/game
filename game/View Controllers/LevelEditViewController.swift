import UIKit
import SceneKit

protocol LevelEditViewControllerDelegate: class {
    func didEdit(level: Level)
}

class LevelEditViewController: UIViewController {
    
    weak var delegate: LevelEditViewControllerDelegate?
    let tileSize: CGFloat = 50
    
    var contentSize: CGSize {
        return CGSize(width: (CGFloat(level.size.x) * tileSize) + tileSize, height: (CGFloat(level.size.z) * tileSize) + tileSize)
    }
    
    private lazy var types: [TileType] = [.wall, .coin, .sphere, .laser, .start, .end]
    
    var startPosition: Float2?
    var endPosition: Float2?
    var laserStartPosition: Float2?
    var lasers: [Laser] = []
    var laserViews: [UIView] = []
    
    private lazy var typeControl: UISegmentedControl = {
        let view = UISegmentedControl(items: [TileType.wall.rawValue, TileType.coin.rawValue, TileType.sphere.rawValue, TileType.laser.rawValue, TileType.start.rawValue, TileType.end.rawValue])
        view.backgroundColor = .white
        
        return view
    }()
    
    private lazy var doneButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 20, y: 60, width: 44, height: 44))
        view.backgroundColor = .red
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        view.addTarget(self, action: #selector(dismiss(_:)), for: .touchUpInside)
        
        return view
    }()
    
    private lazy var clearButton: UIButton = {
        let view = UIButton(frame: CGRect(x: 84, y: 60, width: 44, height: 44))
        view.backgroundColor = .blue
        view.layer.cornerRadius = 22
        view.clipsToBounds = true
        view.addTarget(self, action: #selector(clear(_:)), for: .touchUpInside)
        
        return view
    }()
    
    private lazy var contentView = UIView(frame: CGRect(origin: .zero, size: contentSize))
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.contentSize = contentSize
        scrollView.contentInset.top = 100
        scrollView.contentInset.bottom = 100
        scrollView.minimumZoomScale = 0.3
        scrollView.maximumZoomScale = 2
        scrollView.delegate = self
        
        scrollView.zoomScale = scrollView.minimumZoomScale
        
        return scrollView
    }()
    
    let level: Level
    var tileViews: [LevelEditTileView] = []
    
    required init(with level: Level) {
        self.level = level
        self.lasers = level.lasers
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLaserViews() {
        laserViews.forEach { $0.removeFromSuperview() }
        laserViews = lasers.map { UIView(frame: CGRect(x: CGFloat($0.startPosition.x) * tileSize, y: CGFloat($0.startPosition.z) * tileSize, width: (CGFloat($0.vector.x) * tileSize) + tileSize, height: (CGFloat($0.vector.z) * tileSize) + tileSize)) }
        laserViews.forEach { $0.isUserInteractionEnabled = false; $0.backgroundColor = UIColor.orange.withAlphaComponent(0.5); contentView.addSubview($0) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        automaticallyAdjustsScrollViewInsets = false
        edgesForExtendedLayout = []
        
        view.addSubview(scrollView)
        view.addSubview(typeControl)
        view.addSubview(doneButton)
        view.addSubview(clearButton)
        scrollView.addSubview(contentView)
        
        typeControl.center = CGPoint(x: view.center.x, y: view.bounds.height - tileSize)
        
        for z in 0...Int(level.size.z) {
            for x in 0...Int(level.size.x) {
                let position = Float2(Float(x), Float(z))
                let type: TileType
                
                if position == level.start {
                    type = .start
                    startPosition = position
                } else if position == level.end {
                    type = .end
                    endPosition = position
                } else if level.walls.contains(where: { $0 == position }) {
                    type = .wall
                } else if level.coins.contains(where: { $0 == position }) {
                    type = .coin
                } else if level.spheres.contains(where: { $0 == position }) {
                    type = .sphere
                } else if lasers.contains(where: { $0.startPosition == position || $0.endPosition == position }) {
                    type = .laser
                } else {
                    type = .none
                }
                
                let tileView = LevelEditTileView(type: type, position: position)
                tileView.frame = CGRect(x: CGFloat(x) * tileSize, y: CGFloat(z) * tileSize, width: tileSize, height: tileSize)
                tileView.tapGestureRecognizer.addTarget(self, action: #selector(tappedTileView(_:)))
                contentView.addSubview(tileView)
                
                tileViews.append(tileView)
            }
        }
        
        updateLaserViews()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return true
    }
    
    @objc func tappedTileView(_ gestureRecognizer: UITapGestureRecognizer) {
        
        if let tileView = gestureRecognizer.view as? LevelEditTileView, let type = types[safe: typeControl.selectedSegmentIndex] {
            var oldStartPositions: [LevelEditTileView]?
            var oldEndPositions: [LevelEditTileView]?
            var removedLaserTileViews: [LevelEditTileView]?
            
            switch type {
            case .laser:
                if tileView.type == type {
                    let affectedLaser: Laser? = lasers.filter { $0.startPosition == tileView.position || $0.endPosition == tileView.position }.first
                    if let affectedLaser = affectedLaser {
                        lasers = lasers.filter { $0.startPosition != affectedLaser.startPosition && $0.endPosition != affectedLaser.endPosition }
                        removedLaserTileViews = tileViews.filter { $0.position == affectedLaser.startPosition || $0.position == affectedLaser.endPosition }
                    }
                } else if let laserStartPosition = laserStartPosition {
                    let vector = tileView.position - laserStartPosition
                    if vector.x.isZero || vector.z.isZero {
                        lasers.append(Laser(timeIntervals: [], startPosition: laserStartPosition, vector: vector))
                        self.laserStartPosition = nil
                    } else {
                        return
                    }
                } else {
                    laserStartPosition = tileView.position
                }
            case .start:
                oldStartPositions = tileViews.filter { $0.type == .start }
                startPosition = tileView.position
            case .end:
                oldEndPositions = tileViews.filter { $0.type == .end }
                endPosition = tileView.position
            default: break
            }
            
            tileView.setTileType(tileView.type == type ? .none : type)
            
            oldStartPositions?.forEach { $0.setTileType(.none) }
            oldEndPositions?.forEach { $0.setTileType(.none) }
            removedLaserTileViews?.forEach { $0.setTileType(.none) }
        }
        
        updateLaserViews()
    }
    
    @objc func dismiss(_ buttone: UIButton) {
        guard let start = startPosition else { return }
        guard let end = endPosition else { return }
        let walls = tileViews.filter { $0.type == .wall }.map { $0.position }
        let coins = tileViews.filter { $0.type == .coin }.map { $0.position }
        let spheres = tileViews.filter { $0.type == .sphere }.map { $0.position }
        
        delegate?.didEdit(level: Level(index: level.index, size: level.size, start: start, end: end, walls: walls, coins: coins, spheres: spheres, lasers: lasers))
        dismiss(animated: true)
    }
    
    @objc func clear(_ buttone: UIButton) {
        tileViews.forEach { $0.setTileType(.none) }
        laserViews.forEach { $0.removeFromSuperview() }
        startPosition = nil
        endPosition = nil
        laserStartPosition = nil
        lasers = []
    }
}

extension LevelEditViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
        
        contentView.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)
    }
}


