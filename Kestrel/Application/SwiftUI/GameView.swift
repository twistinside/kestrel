import MetalKit
import SwiftUI

struct GameView: View {
    var body: some View {
        ZStack {
            MetalView()
            UIView()
        }
    }

    init() {
        print("Initializing game view.")
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
