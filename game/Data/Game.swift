import Foundation
import UIKit
import Extras

struct GameIndex: Codable {
    let world: Int
    let level: Int
}

class Game: Codable {
    var worlds: [World]
    var index: GameIndex
    
    init(worlds: [World], index: GameIndex) {
        self.worlds = worlds
        self.index = index
    }
    
    static var empty: Game {
        return Game(worlds: [World.empty(index: 0)], index: GameIndex(world: 0, level: 0))
    }
    
    var currentLevel: Level {
        return worlds[index.world].levels[index.level]
    }
    
    func level(for index: GameIndex) -> Level {
        return worlds[index.world].levels[index.level]
    }
}

extension Game {
    
    func saveLevel(_ level: Level) {
        worlds[level.index.world].levels[level.index.level] = level
        save()
    }
}

extension Game {
    private static let fileName = "game.json"
    
    func save() {
        let fileManager = FileManager()
        let url = FileManager.documentDirectory.appendingPathComponent(Game.fileName)
        
        do {
            if fileManager.fileExists(atPath: url.path) {
                try? fileManager.removeItem(at: url)
            }
            
            if let data = try? JSONEncoder().encode(self) {
                fileManager.createFile(atPath: url.path, contents: data, attributes: nil)
            }
        }
    }
    
    static func load() -> Game? {
        let fileManager = FileManager()
        let path = FileManager.documentDirectory.appendingPathComponent(Game.fileName).path
        
        if fileManager.fileExists(atPath: path), let data = fileManager.contents(atPath: path) {
            return try? JSONDecoder().decode(Game.self, from: data)
        }
        
        return nil
    }
}
