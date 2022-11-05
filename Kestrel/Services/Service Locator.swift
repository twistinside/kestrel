// This class is based on reading done at https://gameprogrammingpatterns.com/service-locator.html
import Touchy

class ServiceLocator {
    static let shared = ServiceLocator()

    private(set) var inputController: TCHInputController
    private(set) var renderer: Renderer

    private init() {
        self.inputController = TCHStandardInputController()
        self.renderer = Renderer()
    }
}
