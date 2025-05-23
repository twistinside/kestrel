import MetalKit
import os
import SwiftUI

struct GameView: View {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: GameView.self)
    )

    var body: some View {
        ZStack {
            MetalView()
            UIView()
        }
    }

    init() {
        GameView.logger.trace("Initializing game view")
        // registering events just to turn off beeping
        // keyboard events will be handled through GCKeyboard
        // https://stackoverflow.com/questions/67410511/macos-swiftui-2-simplest-way-to-turn-off-beep-on-keystroke
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { _ in return nil }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
