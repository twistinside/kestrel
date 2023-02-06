import MetalKit
import SwiftUI

class RenderSettings: ObservableObject {
    static let shared = RenderSettings()

    @Published var geometryType: MDLGeometryType = .triangles
    @Published var primitiveType: MTLPrimitiveType = .triangle
    @Published var clearColor: MTLClearColor = MTLClearColor.maroon
}
