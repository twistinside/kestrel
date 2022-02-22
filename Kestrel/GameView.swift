//
//  ContentView.swift
//  Kestrel
//
//  Created by Karl Groff on 2/17/22.
//

import MetalKit
import SwiftUI

struct GameView: View {
    var body: some View {
        MetalView()
            .frame(width: 350, height: 350)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
