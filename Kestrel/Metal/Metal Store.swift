import Foundation
import Metal
import MetalKit
import os

class MetalStore: ObservableObject {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: MetalStore.self)
    )

    static let shared = MetalStore()

    let commandQueue: MTLCommandQueue
    let device: MTLDevice
    let library: MTLLibrary
    let meshBufferAllocator: MTKMeshBufferAllocator

    init() {
        MetalStore.logger.trace("Initializing metal store")

        guard let device = MTLCreateSystemDefaultDevice(),
              let commandQueue = device.makeCommandQueue(),
              let library = device.makeDefaultLibrary() else {
            MetalStore.logger.critical("Could not initialize metal sub system")
            fatalError()
        }
        self.commandQueue = commandQueue
        self.device = device
        self.library = library
        self.meshBufferAllocator = MTKMeshBufferAllocator(device: device)

        MetalStore.logger.trace("Initialization complete")
    }
}
