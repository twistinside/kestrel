import SwiftUI

struct UIView: View {

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
        print("Initializing UI view.")
    }
}

struct UIView_Previews: PreviewProvider {
    static var previews: some View {
        UIView()
    }
}
