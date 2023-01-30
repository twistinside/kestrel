// This class is based on reading done at https://gameprogrammingpatterns.com/service-locator.html
import Foundation

class ServiceLocator: ObservableObject {
    static let shared = ServiceLocator()

    private(set) var renderer: Renderer

    private init() {
        print("Initializing service locator.")
        self.renderer = Renderer.shared
    }
}
