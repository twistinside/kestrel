// This class is based on reading done at https://gameprogrammingpatterns.com/service-locator.html

class ServiceLocator {
    static let shared = ServiceLocator()
    
    private(set) var renderer: Renderer
    
    private init() {
        self.renderer = Renderer()
    }
}
