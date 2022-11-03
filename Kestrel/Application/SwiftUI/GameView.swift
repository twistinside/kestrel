import MetalKit
import SwiftUI

struct GameView: View {
    var body: some View {
        VStack {
            MetalView()
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
