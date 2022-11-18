import Foundation
import Metal

class MetalStorage: ObservableObject {
    static let shared = MetalStorage()

    let commandQueue: MTLCommandQueue
    let device: MTLDevice
    var fragmentFunction: MTLFunction
    var library: MTLLibrary
    var vertexFunction: MTLFunction

    init() {
        print("Initializing metal storage object.")
        guard let device = MTLCreateSystemDefaultDevice(),
              let commandQueue = device.makeCommandQueue(),
              let library = device.makeDefaultLibrary(),
              let vertexFunction = library.makeFunction(name: "basic_vertex"),
              let fragmentFunction = library.makeFunction(name: "basic_fragment") else {
            fatalError("Could not initialize metal sub system.")
        }
        self.commandQueue = commandQueue
        self.device = device
        self.fragmentFunction = fragmentFunction
        self.library = library
        self.vertexFunction = vertexFunction
    }
}
