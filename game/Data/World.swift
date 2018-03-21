import Foundation

struct World: Codable {
    var levels: [Level]
    
    static func empty(index: Int) -> World {
        return World(levels: [
            Level.empty(index: GameIndex(world: index, level: 0)),
            Level.empty(index: GameIndex(world: index, level: 1)),
            Level.empty(index: GameIndex(world: index, level: 2)),
            Level.empty(index: GameIndex(world: index, level: 3)),
            Level.empty(index: GameIndex(world: index, level: 4)),
            Level.empty(index: GameIndex(world: index, level: 5)),
            Level.empty(index: GameIndex(world: index, level: 6)),
            Level.empty(index: GameIndex(world: index, level: 7)),
            ])
    }
}
