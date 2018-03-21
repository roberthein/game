import Foundation

struct Level: Codable {
    var index: GameIndex
    var size: Float2
    var start: Float2
    var end: Float2
    var walls: [Float2]
    var coins: [Float2]
    var spheres: [Float2]
    var lasers: [Laser]
    
    static func empty(index: GameIndex) -> Level {
        return Level(index: index, size: .levelSize, start: .zero, end: Float2(100, 100), walls: [], coins: [], spheres: [], lasers: [])
    }
}
