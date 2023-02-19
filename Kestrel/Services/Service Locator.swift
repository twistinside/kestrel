// This class is based on reading done at https://gameprogrammingpatterns.com/service-locator.html
import Foundation
import os

class ServiceLocator {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: ServiceLocator.self)
    )

    static let shared = ServiceLocator()

    private(set) var inputHandler: InputHandler
    private(set) var renderer: Renderer

    private init() {
        ServiceLocator.logger.trace("Initializing service locator")
        self.inputHandler = InputHandler.shared
        self.renderer = Renderer.shared
        ServiceLocator.logger.trace("Initialization complete")
    }
}
