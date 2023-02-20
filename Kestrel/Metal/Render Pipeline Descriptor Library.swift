import MetalKit
import os

class RenderPiplelineDescriptorLibrary {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: RenderPiplelineDescriptorLibrary.self)
    )

    static let shared = RenderPiplelineDescriptorLibrary()

    private let renderPipelineDescriptors: [RenderPipelineDescriptorName: MTLRenderPipelineDescriptor]

    init() {
        RenderPiplelineDescriptorLibrary.logger.trace("Initializing render pipeline descriptor library")
        var renderPipelineDescriptors: [RenderPipelineDescriptorName: MTLRenderPipelineDescriptor] = [:]

        let mdlMesh = MDLMesh(sphereWithExtent: [0.8, 0.8, 0.8],
                              segments: [100, 100],
                              inwardNormals: false,
                              geometryType: .triangles,
                              allocator: MetalStore.shared.meshBufferAllocator)
        let mtkMesh = try! MTKMesh(mesh: mdlMesh, device: MetalStore.shared.device)

        var renderPipelineDescriptor = MTLRenderPipelineDescriptor()

        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineDescriptor.depthAttachmentPixelFormat = MTLPixelFormat.depth32Float
        renderPipelineDescriptor.vertexFunction = ShaderLibrary.shared.getShaderNamed(.basicVertex)
        renderPipelineDescriptor.fragmentFunction = ShaderLibrary.shared.getShaderNamed(.basicFragment)
        renderPipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mtkMesh.vertexDescriptor)

        renderPipelineDescriptors[.basic] = renderPipelineDescriptor

        renderPipelineDescriptor = MTLRenderPipelineDescriptor()

        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineDescriptor.depthAttachmentPixelFormat = MTLPixelFormat.depth32Float
        renderPipelineDescriptor.vertexFunction = ShaderLibrary.shared.getShaderNamed(.basicVertex)
        renderPipelineDescriptor.fragmentFunction = ShaderLibrary.shared.getShaderNamed(.monoFragment)
        renderPipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mtkMesh.vertexDescriptor)

        renderPipelineDescriptors[.mono] = renderPipelineDescriptor

        renderPipelineDescriptor = MTLRenderPipelineDescriptor()

        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineDescriptor.depthAttachmentPixelFormat = MTLPixelFormat.depth32Float
        renderPipelineDescriptor.vertexFunction = ShaderLibrary.shared.getShaderNamed(.basicVertex)
        renderPipelineDescriptor.fragmentFunction = ShaderLibrary.shared.getShaderNamed(.monoWeightedFragment)
        renderPipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mtkMesh.vertexDescriptor)

        renderPipelineDescriptors[.monoWeighted] = renderPipelineDescriptor

        renderPipelineDescriptor = MTLRenderPipelineDescriptor()

        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineDescriptor.depthAttachmentPixelFormat = MTLPixelFormat.depth32Float
        renderPipelineDescriptor.vertexFunction = ShaderLibrary.shared.getShaderNamed(.basicVertex)
        renderPipelineDescriptor.fragmentFunction = ShaderLibrary.shared.getShaderNamed(.monoRedFragment)
        renderPipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mtkMesh.vertexDescriptor)

        renderPipelineDescriptors[.monoRed] = renderPipelineDescriptor

        renderPipelineDescriptor = MTLRenderPipelineDescriptor()

        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineDescriptor.depthAttachmentPixelFormat = MTLPixelFormat.depth32Float
        renderPipelineDescriptor.vertexFunction = ShaderLibrary.shared.getShaderNamed(.basicVertex)
        renderPipelineDescriptor.fragmentFunction = ShaderLibrary.shared.getShaderNamed(.monoGreenFragment)
        renderPipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mtkMesh.vertexDescriptor)

        renderPipelineDescriptors[.monoGreen] = renderPipelineDescriptor

        renderPipelineDescriptor = MTLRenderPipelineDescriptor()

        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineDescriptor.depthAttachmentPixelFormat = MTLPixelFormat.depth32Float
        renderPipelineDescriptor.vertexFunction = ShaderLibrary.shared.getShaderNamed(.basicVertex)
        renderPipelineDescriptor.fragmentFunction = ShaderLibrary.shared.getShaderNamed(.monoBlueFragment)
        renderPipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mtkMesh.vertexDescriptor)

        renderPipelineDescriptors[.monoBlue] = renderPipelineDescriptor

        self.renderPipelineDescriptors = renderPipelineDescriptors

        // Validate the render pipeline descriptor library is complete
        for name in RenderPipelineDescriptorName.allCases {
            guard let _ = renderPipelineDescriptors[name] else {
                RenderPiplelineDescriptorLibrary.logger.error("Initialization failed, \(name.rawValue) was not present in the library")
                fatalError()
            }
        }

        RenderPiplelineDescriptorLibrary.logger.trace("Initialization complete")
    }

    func getRenderPipelineDescriptorNamed(_ name: RenderPipelineDescriptorName) -> MTLRenderPipelineDescriptor {
        return renderPipelineDescriptors[name]!
    }
}

enum RenderPipelineDescriptorName: String, CaseIterable {
    case basic
    case mono
    case monoWeighted
    case monoRed
    case monoGreen
    case monoBlue
}
