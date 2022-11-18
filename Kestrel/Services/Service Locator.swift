// This class is based on reading done at https://gameprogrammingpatterns.com/service-locator.html
import Foundation
import Touchy

class ServiceLocator: ObservableObject {
    static let shared = ServiceLocator()

    private(set) var inputController = TCHStandardInputController()
    private(set) var renderer = Renderer.shared

    private init() {
        print("Initializing service locator.")
    }
}
