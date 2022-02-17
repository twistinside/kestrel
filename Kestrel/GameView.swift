//
//  ContentView.swift
//  Kestrel
//
//  Created by Karl Groff on 2/17/22.
//

import MetalKit
import SwiftUI

struct GameView: NSViewRepresentable {
    func makeCoordinator() -> Renderer {
        Renderer(self)
    }
    
    func makeNSView(context: NSViewRepresentableContext<GameView>) -> MTKView {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Could not create metal device.")
        }
        
        let mtkView = MTKView()
    
        mtkView.delegate = context.coordinator
        mtkView.preferredFramesPerSecond = 60
        mtkView.enableSetNeedsDisplay = true
        mtkView.device = device
        mtkView.framebufferOnly = false
        mtkView.clearColor = MTLClearColor(red: 0.73, green: 0.23, blue: 0.35, alpha: 1.0)
        mtkView.drawableSize = mtkView.frame.size
        
        return mtkView
    }
    
    func updateNSView(_ nsView: MTKView, context: NSViewRepresentableContext<GameView>) {
        // Do nothing
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
