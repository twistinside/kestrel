import MetalKit
import os
import SwiftUI

struct DebugView: View {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: DebugView.self)
    )

    @EnvironmentObject var renderSettings: RenderSettings

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
        DebugView.logger.trace("Initializing debug view")
    }

    func setBlack() {
        setClearColor(MTLClearColor.black)
    }

    func setMaroon() {
        setClearColor(MTLClearColor.maroon)
    }

    func setClearColor(_ clearColor: MTLClearColor) {
        renderSettings.clearColor = clearColor
    }

    func setLine() {
        setPrimitiveType(.line)
    }

    func setTriangle() {
        setPrimitiveType(.triangle)
    }

    func setPrimitiveType(_ primitiveType: MTLPrimitiveType) {
        renderSettings.primitiveType = primitiveType
    }
}

struct DebugView_Previews: PreviewProvider {
    static var previews: some View {
        DebugView().environmentObject(RenderSettings())
    }
}
