import MetalKit
import os

class RenderPiplelineStateLibrary {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: RenderPiplelineStateLibrary.self)
    )

    static let shared = RenderPiplelineStateLibrary()

    private let renderPipelineStates: [RenderPipelineStateName: MTLRenderPipelineState]

    init() {
        RenderPiplelineStateLibrary.logger.trace("Initializing render pipeline state library")
        var renderPipelineStates: [RenderPipelineStateName: MTLRenderPipelineState] = [:]

        var renderPipelineDescriptor = RenderPiplelineDescriptorLibrary.shared.getRenderPipelineDescriptorNamed(.basic)
        do {
            let renderPipelineState =
                try MetalStore.shared.device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
            renderPipelineStates[.basic] = renderPipelineState
        } catch {
            RenderPiplelineStateLibrary.logger.critical("Could not create render pipeline state")
            fatalError()
        }

        renderPipelineDescriptor = RenderPiplelineDescriptorLibrary.shared.getRenderPipelineDescriptorNamed(.mono)
        do {
            let renderPipelineState =
                try MetalStore.shared.device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
            renderPipelineStates[.mono] = renderPipelineState
        } catch {
            RenderPiplelineStateLibrary.logger.critical("Could not create render pipeline state")
            fatalError()
        }

        renderPipelineDescriptor = RenderPiplelineDescriptorLibrary.shared.getRenderPipelineDescriptorNamed(.monoWeighted)
        do {
            let renderPipelineState =
            try MetalStore.shared.device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
            renderPipelineStates[.monoWeighted] = renderPipelineState
        } catch {
            RenderPiplelineStateLibrary.logger.critical("Could not create render pipeline state")
            fatalError()
        }

        renderPipelineDescriptor = RenderPiplelineDescriptorLibrary.shared.getRenderPipelineDescriptorNamed(.monoRed)
        do {
            let renderPipelineState =
            try MetalStore.shared.device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
            renderPipelineStates[.monoRed] = renderPipelineState
        } catch {
            RenderPiplelineStateLibrary.logger.critical("Could not create render pipeline state")
            fatalError()
        }

        renderPipelineDescriptor = RenderPiplelineDescriptorLibrary.shared.getRenderPipelineDescriptorNamed(.monoGreen)
        do {
            let renderPipelineState =
            try MetalStore.shared.device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
            renderPipelineStates[.monoGreen] = renderPipelineState
        } catch {
            RenderPiplelineStateLibrary.logger.critical("Could not create render pipeline state")
            fatalError()
        }

        renderPipelineDescriptor = RenderPiplelineDescriptorLibrary.shared.getRenderPipelineDescriptorNamed(.monoBlue)
        do {
            let renderPipelineState =
            try MetalStore.shared.device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
            renderPipelineStates[.monoBlue] = renderPipelineState
        } catch {
            RenderPiplelineStateLibrary.logger.critical("Could not create render pipeline state")
            fatalError()
        }

        self.renderPipelineStates = renderPipelineStates

        // Validate the render pipeline state library is complete
        for name in RenderPipelineStateName.allCases {
            guard let _ = renderPipelineStates[name] else {
                RenderPiplelineStateLibrary.logger.error("Initialization failed, \(name.rawValue) was not present in the library")
                fatalError()
            }
        }

        RenderPiplelineStateLibrary.logger.trace("Initialization complete")
    }

    func getRenderPipelineStateNamed(_ name: RenderPipelineStateName) -> MTLRenderPipelineState {
        return renderPipelineStates[name]!
    }
}

enum RenderPipelineStateName: String, CaseIterable {
    case basic
    case mono
    case monoWeighted
    case monoRed
    case monoGreen
    case monoBlue
}
