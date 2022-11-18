import MetalKit

extension MTLClearColor {
    static func black() -> MTLClearColor {
        MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    }

    static func maroon() -> MTLClearColor {
        MTLClearColor(red: 0.73, green: 0.23, blue: 0.35, alpha: 1.0)
    }

    static func white() -> MTLClearColor {
        MTLClearColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
}
