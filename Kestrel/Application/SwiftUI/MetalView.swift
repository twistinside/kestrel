import SwiftUI
import MetalKit

struct MetalView: View {
    @State private var metalView = MTKView()
    @State private var renderer: Renderer?

    var body: some View {
        MetalViewRepresentable(metalView: $metalView)
            .onAppear { renderer = Renderer.shared }
    }

    init() {
        print("Initializing metal view.")
    }
}

struct MetalViewRepresentable: NSViewRepresentable {
    @Binding var metalView: MTKView

    func makeNSView(context: Context) -> some NSView {
        metalView.clearColor = MTLClearColor(red: 0.73, green: 0.23, blue: 0.35, alpha: 1.0)
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
