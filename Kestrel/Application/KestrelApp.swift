import GameKit
import SwiftUI

@main
struct KestrelApp: App {
    @StateObject var game = Kestrel.shared
    @StateObject var metal = MetalStore.shared
    @StateObject var services = ServiceLocator.shared

    init() {
        print("Initializing kestrel app.")
        print("Controllers discovered: \(GCController.controllers()))")
    }

    var body: some Scene {
        WindowGroup {
            GameView()
                .environmentObject(game)
                .frame(minWidth: 800, maxWidth: .infinity, minHeight: 800, maxHeight: .infinity, alignment: .center)
        }
    }
}
