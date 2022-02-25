import MetalKit
import SwiftUI

struct GameView: View {
    var body: some View {
        VStack{
            MetalView()
                .frame(width: 350, height: 350)
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
