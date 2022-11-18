import Foundation
import MetalKit

class Kestrel: ObservableObject {
    static let shared = Kestrel()

    @Published var geometryType: MDLGeometryType = .triangles
    @Published var primitiveType: MTLPrimitiveType = .triangle
    @Published var clearColor: MTLClearColor = MTLClearColor(red: 0.73,
                                                             green: 0.23,
                                                             blue: 0.35,
                                                             alpha: 1.0)

    private init() {
        print("Initializing kestrel game object.")
    }
}
