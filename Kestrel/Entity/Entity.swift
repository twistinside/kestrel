import Foundation
import os

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

extension Array where Element: Entity {
    func update(deltaTime: Float) {
        self.forEach { $0.update(deltaTime: deltaTime) }
    }
}
