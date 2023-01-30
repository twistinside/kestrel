import MetalKit

class Renderer: NSObject {
    static let shared = Renderer()

    let commandQueue = MetalStore.shared.commandQueue
    let device = MetalStore.shared.device
    let game = Kestrel.shared

    private override init() {
        print("Initializing renderer.")
        super.init()
    }
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        print("View has been resized, it is now \(size.height) tall and \(size.width) wide")
    }

    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable else {
            return
        }

        game.update(deltaTime: 0.01)

        let commandBuffer = commandQueue.makeCommandBuffer()
        let renderPassDescriptor = view.currentRenderPassDescriptor

        renderPassDescriptor?.colorAttachments[0].clearColor = Kestrel.shared.clearColor
        renderPassDescriptor?.colorAttachments[0].loadAction = .clear
        renderPassDescriptor?.colorAttachments[0].storeAction = .store

        let renderCommandEncoder = commandBuffer!.makeRenderCommandEncoder(descriptor: renderPassDescriptor!)

        renderCommandEncoder?.setRenderPipelineState(MetalStore.shared.renderPipelineState)

        game.render(renderCommandEncoder: renderCommandEncoder!)

        renderCommandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
