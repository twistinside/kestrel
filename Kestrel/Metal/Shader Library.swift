import Metal
import os

class ShaderLibrary {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: ShaderLibrary.self)
    )

    static let shared = ShaderLibrary()

    private let shaders: [ShaderName: MTLFunction]

    init() {
        ShaderLibrary.logger.trace("Initializing shader library")
        var shaders: [ShaderName: MTLFunction] = [:]
        let library = MetalStore.shared.library

        for name in ShaderName.allCases {
            ShaderLibrary.logger.trace("Initializing \(name.rawValue)")
            let shader = library.makeFunction(name: name.rawValue)
            shaders[name] = shader
            ShaderLibrary.logger.trace("Initialization of \(name.rawValue) complete")
        }

        self.shaders = shaders
        ShaderLibrary.logger.trace("Initialization complete")
    }

    func getShaderNamed(_ name: ShaderName) -> MTLFunction {
        return shaders[name]!
    }
}

enum ShaderName: String, CaseIterable {
    case basicFragment        = "basic_fragment"
    case basicVertex          = "basic_vertex"
    case monoFragment         = "mono_fragment"
    case monoWeightedFragment = "weighted_mono_fragment"
    case monoRedFragment      = "weighted_mono_red_only_fragment"
    case monoGreenFragment      = "weighted_mono_green_only_fragment"
    case monoBlueFragment      = "weighted_mono_blue_only_fragment"
}
