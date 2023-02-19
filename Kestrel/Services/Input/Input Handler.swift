import GameController
import os

class InputHandler {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: InputHandler.self)
    )

    static let shared = InputHandler()

    init() {
        InputHandler.logger.trace("Initializing input handler")
        // Do nothing
        InputHandler.logger.trace("Initialization complete")
    }

    func keyIsPressed(_ keyCode: GCKeyCode) -> Bool {
        return GCKeyboard.coalesced?.keyboardInput?.button(forKeyCode: keyCode)?.isPressed ?? false
    }
}
