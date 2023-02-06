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
    var meshes: MeshStore
    var metal: MetalStore
    var services: ServiceLocator

    @StateObject var renderSettings: RenderSettings = RenderSettings.shared

    init() {
        KestrelApp.logger.trace("Initializing kestrel app")
        KestrelApp.logger.trace("Controllers discovered: \(GCController.controllers()))")
        self.metal = MetalStore.shared
        self.meshes = MeshStore.shared
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
