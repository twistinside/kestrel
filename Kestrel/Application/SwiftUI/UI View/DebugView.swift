import MetalKit
import SwiftUI

struct DebugView: View {
    @EnvironmentObject var game: Kestrel

    var body: some View {
        VStack {
            Text("Clear Color")
            Button("Black", action: setBlack)
            Button("Maroon", action: setMaroon)
            Text("Primitive Type")
            Button("Lines", action: setLine)
            Button("Triangles", action: setTriangle)
        }.font(.subheadline)
         .foregroundColor(.white)
         .padding(15)
         .background(RoundedRectangle(cornerRadius: 10).fill(Color.black).opacity(0.3))
    }

    init() {
        print("Initializing debug view.")
    }

    func setBlack() {
        setClearColor(MTLClearColor.black)
    }

    func setMaroon() {
        setClearColor(MTLClearColor.maroon)
    }

    func setClearColor(_ clearColor: MTLClearColor) {
        game.clearColor = clearColor
    }

    func setLine() {
        setPrimitiveType(.line)
    }

    func setTriangle() {
        setPrimitiveType(.triangle)
    }

    func setPrimitiveType(_ primitiveType: MTLPrimitiveType) {
        game.primitiveType = primitiveType
    }
}

struct DebugView_Previews: PreviewProvider {
    static var previews: some View {
        DebugView().environmentObject(Kestrel.shared)
    }
}
