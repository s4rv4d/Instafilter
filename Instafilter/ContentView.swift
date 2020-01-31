//
//  ContentView.swift
//  Instafilter
//
//  Created by Sarvad shetty on 1/30/20.
//  Copyright © 2020 Sarvad shetty. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var blurAmount: CGFloat = 0
    
    var body: some View {
        
        let blur = Binding<CGFloat>(
            get: {
                self.blurAmount
        },
            set: {
                self.blurAmount = $0
                print("new val \(self.blurAmount)")
        }
        )
        
        return VStack {
            Text("Hello, World!")
            .blur(radius: blurAmount)
            
            Slider(value: blur, in: 0...20)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
