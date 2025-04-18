import MetalKit
import os
import SwiftUI

struct MetalView: View {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: MetalView.self)
    )

    @State private var metalView = MTKView()
    @State private var renderer: Renderer?

    var body: some View {
        MetalViewRepresentable(metalView: $metalView)
            .onAppear { renderer = Renderer.shared }
    }

    init() {
        MetalView.logger.trace("Initializing metal view")
    }
}

struct MetalViewRepresentable: NSViewRepresentable {
    @Binding var metalView: MTKView

    func makeNSView(context: Context) -> some NSView {
        metalView.clearColor = MTLClearColor(red: 0.73, green: 0.23, blue: 0.35, alpha: 1.0)
        metalView.depthStencilPixelFormat = MTLPixelFormat.depth32Float
        metalView.colorPixelFormat = .bgra8Unorm
        metalView.delegate = ServiceLocator.shared.renderer
        metalView.device = MetalStore.shared.device
        return metalView
    }

    func updateNSView(_ uiView: NSViewType, context: Context) {
        // do nothing
    }
}

struct MetalView_Previews: PreviewProvider {
    static var previews: some View {
        MetalView()
    }
}
