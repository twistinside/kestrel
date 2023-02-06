import os
import SwiftUI

struct UIView: View {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: UIView.self)
    )

    var body: some View {
        HStack {
            Spacer()
            VStack {
                DebugView()
                Spacer()
            }
        }
    }

    init() {
        UIView.logger.trace("Initializing UI view")
    }
}

struct UIView_Previews: PreviewProvider {
    static var previews: some View {
        UIView()
    }
}
