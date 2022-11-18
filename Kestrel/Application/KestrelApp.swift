import SwiftUI

@main
struct KestrelApp: App {
    @StateObject var game = Kestrel.shared
    @StateObject var metal = MetalStorage.shared
    @StateObject var services = ServiceLocator.shared

    init() {
        print("Initializing kestrel app.")
    }

    var body: some Scene {
        WindowGroup {
            GameView()
                .environmentObject(game)
        }
    }
}
