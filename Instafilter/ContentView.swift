//
//  ContentView.swift
//  Instafilter
//
//  Created by Sarvad shetty on 1/30/20.
//  Copyright © 2020 Sarvad shetty. All rights reserved.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {

    @State private var image: Image?
    
    var body: some View {
        VStack {
            image?
            .resizable()
            .scaledToFit()
        }
    .onAppear(perform: loadExample)
    }
    
    func loadExample() {
        guard let inputImage = UIImage(named: "Example") else { return }
        let beginImage = CIImage(image: inputImage)
        
        let context = CIContext()
//        let currentFilter = CIFilter.crystallize()
//
//        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
//        currentFilter.radius = 200
        
        guard let currentFilter = CIFilter(name: "CITwirlDistortion") else { return }
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter.setValue(200, forKey: kCIInputRadiusKey)
        currentFilter.setValue(CIVector(x: inputImage.size.width / 2, y: inputImage.size.height / 2), forKey: kCIInputCenterKey)
        
        //steps to get Image
        //get CIImage from our filter output
        guard let outputImage = currentFilter.outputImage else { return }
        //attempt to get CGImage from CIImage
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            //convert cgimage into uiimage
            let uiimage = UIImage(cgImage: cgimg)
            //convert uiimage into image
            image = Image(uiImage: uiimage)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
