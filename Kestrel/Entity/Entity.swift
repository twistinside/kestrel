import Foundation

class Entity {
    let uuid: UUID = UUID()
    let name: String?
    
    init(name: String? = nil) {
        self.name = name
    }
    
    func update(deltaTime: Float) {
        // do nothing in this base class
    }
}
