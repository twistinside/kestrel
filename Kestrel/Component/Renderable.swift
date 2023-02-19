import GameController
import MetalKit
import YuzuKit

protocol Renderable: Entity {
    var meshes: [MTKMesh] { get }
    var position: SIMD3<Float> { get }
    var renderPipelineState: MTLRenderPipelineState { get }
    var rotation: SIMD3<Float> { get }
    var scale: SIMD3<Float> { get }

    func render(renderCommandEncoder: MTLRenderCommandEncoder)
}

extension Renderable {
    func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        for mesh in meshes {
            for vertexBuffer in mesh.vertexBuffers {
                var modelMatrix = YZKModelMatrix.from(position: position, rotation: rotation, scale: scale)
                let random = Bool.random()
                var renderPipelineStateName: RenderPipelineStateName

                let rKeyIsPressed: Bool = GCKeyboard.coalesced?.keyboardInput?.button(forKeyCode: .keyR)?.isPressed ?? false
                let gKeyIsPressed: Bool = GCKeyboard.coalesced?.keyboardInput?.button(forKeyCode: .keyG)?.isPressed ?? false
                let bKeyIsPressed: Bool = GCKeyboard.coalesced?.keyboardInput?.button(forKeyCode: .keyB)?.isPressed ?? false

                if rKeyIsPressed {
                    renderPipelineStateName = .monoRed
                } else if gKeyIsPressed {
                    renderPipelineStateName = .monoGreen
                } else if bKeyIsPressed {
                    renderPipelineStateName = .monoBlue
                } else {
                    renderPipelineStateName = .basic
                }
                let renderPipelineState = RenderPiplelineStateLibrary.shared.getRenderPipelineStateNamed(renderPipelineStateName)
                renderCommandEncoder.setRenderPipelineState(renderPipelineState)
                renderCommandEncoder.setVertexBytes(&modelMatrix,
                                                    length: MemoryLayout<matrix_float4x4>.stride,
                                                    index: 1)
                renderCommandEncoder.setVertexBuffer(vertexBuffer.buffer, offset: vertexBuffer.offset, index: 0)
                for submesh in mesh.submeshes {
                    renderCommandEncoder.drawIndexedPrimitives(type: RenderSettings.shared.primitiveType,
                                                               indexCount: submesh.indexCount,
                                                               indexType: submesh.indexType,
                                                               indexBuffer: submesh.indexBuffer.buffer,
                                                               indexBufferOffset: submesh.indexBuffer.offset,
                                                               instanceCount: 1)
                }
            }
        }
    }
}

extension Array where Element: Renderable {
    func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        self.forEach { $0.render(renderCommandEncoder: renderCommandEncoder) }
    }
}
