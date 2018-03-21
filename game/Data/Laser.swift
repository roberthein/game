import Foundation
import UIKit

struct Laser: Codable {
    let timeIntervals: [TimeInterval]
    let startPosition: Float2
    let vector: Float2
    
    enum CodingKeys: String, CodingKey {
        case timeIntervals
        case startPosition
        case vector
    }
    
    init(timeIntervals: [TimeInterval], startPosition: Float2, vector: Float2) {
        self.timeIntervals = timeIntervals
        self.startPosition = startPosition
        self.vector = vector
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        timeIntervals = try container.decode([TimeInterval].self, forKey: .timeIntervals)
        startPosition = try container.decode(Float2.self, forKey: .startPosition)
        vector = try container.decode(Float2.self, forKey: .vector)
    }
}

extension Laser {
    
    var endPosition: Float2 {
        return startPosition + vector
    }
}
