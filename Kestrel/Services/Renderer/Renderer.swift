import MetalKit
import os

class Renderer: NSObject {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: Renderer.self)
    )

    static let shared = Renderer()

    let commandQueue = MetalStore.shared.commandQueue
    let device = MetalStore.shared.device
    let game = Kestrel.shared

    private override init() {
        Renderer.logger.trace("Initializing renderer")
        super.init()
        Renderer.logger.trace("Initialization complete")
    }
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        Renderer.logger.trace("View has been resized, it is now \(size.height) tall and \(size.width) wide")
    }

    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable else {
            return
        }

        game.update(deltaTime: 0.01)

        guard let commandBuffer = commandQueue.makeCommandBuffer(),
              let renderPassDescriptor = view.currentRenderPassDescriptor else {
            fatalError("Could not get command buffer")
        }

        renderPassDescriptor.colorAttachments[0].clearColor = RenderSettings.shared.clearColor
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].storeAction = .store

        guard let renderCommandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            fatalError("Could not get render command encoder")
        }

        game.render(renderCommandEncoder: renderCommandEncoder)

        renderCommandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
