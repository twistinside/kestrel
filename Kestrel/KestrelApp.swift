import GameKit
import os
import SwiftUI

@main
struct KestrelApp: App {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: KestrelApp.self)
    )

    var game: Kestrel
    var meshes: MeshLibrary
    var metal: MetalStore
    var renderPipelineDescriptors: RenderPiplelineDescriptorLibrary
    var renderPipelineStates: RenderPiplelineStateLibrary
    var services: ServiceLocator
    var shaders: ShaderLibrary
    var vertexDescriptors: VertexDescriptorLibrary

    @StateObject var renderSettings: RenderSettings = RenderSettings.shared

    init() {
        KestrelApp.logger.trace("Initializing kestrel app")
        KestrelApp.logger.trace("Controllers discovered: \(GCController.controllers()))")
        self.metal = MetalStore.shared
        self.vertexDescriptors = VertexDescriptorLibrary.shared
        self.meshes = MeshLibrary.shared
        self.shaders = ShaderLibrary.shared
        self.renderPipelineDescriptors = RenderPiplelineDescriptorLibrary.shared
        self.renderPipelineStates = RenderPiplelineStateLibrary.shared
        self.game = Kestrel.shared
        self.services = ServiceLocator.shared
        KestrelApp.logger.trace("Initialization complete")
    }

    var body: some Scene {
        WindowGroup {
            GameView()
                .environmentObject(renderSettings)
                .frame(minWidth: 800, maxWidth: .infinity, minHeight: 800, maxHeight: .infinity, alignment: .center)
        }
    }
}
