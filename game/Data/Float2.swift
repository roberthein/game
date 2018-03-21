import Foundation
import SceneKit

struct Float2: Codable {
    var x: Float
    var z: Float
    
    init(_ x: Float, _ z: Float) {
        self.x = x
        self.z = z
    }
}

extension Float2 {
    
    static var zero: Float2 {
        return Float2(0, 0)
    }
    
    var isZero: Bool {
        return x.isZero && z.isZero
    }
    
    var vector3: SCNVector3 {
        return SCNVector3(x, 0, z)
    }
}

extension Float2 {
    
    static var levelSize: Float2 {
        return Float2(20, 20)
    }
}

func ==(lhs: Float2, rhs: Float2) -> Bool {
    return lhs.x == rhs.x && lhs.z == rhs.z
}

func !=(lhs: Float2, rhs: Float2) -> Bool {
    return lhs.x != rhs.x && lhs.z != rhs.z
}

func +=(lhs: inout Float2, rhs: Float2) {
    lhs = lhs + rhs
}

func -=(lhs: inout Float2, rhs: Float2) {
    lhs = lhs - rhs
}

func +(lhs: Float2, rhs: Float2) -> Float2 {
    return Float2(lhs.x + rhs.x, lhs.z + rhs.z)
}

func -(lhs: Float2, rhs: Float2) -> Float2 {
    return Float2(lhs.x - rhs.x, lhs.z - rhs.z)
}
