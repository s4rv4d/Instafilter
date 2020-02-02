//
//  ContentView.swift
//  Instafilter
//
//  Created by Sarvad shetty on 1/30/20.
//  Copyright © 2020 Sarvad shetty. All rights reserved.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct ContentView: View {
    
    //MARK: - Binding variables
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    @State private var showingFilterSheet = false
    @State private var processedImage: UIImage?
    
    //MARK: - Variables
    let context = CIContext()

    var body: some View {
        //need to add custom binding to reflect chnages in intensity value
        let intensity = Binding<Double>(
            get: {
                self.filterIntensity
            },
            set: {
                self.filterIntensity = $0
                self.applyProcessing()
            }
        )
        
        return NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.secondary)
                    
                    //display the image
                    if image != nil {
                        image?
                        .resizable()
                        .scaledToFit()
                    } else {
                        Text("Select a picture")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }
                .onTapGesture {
                    //select the image
                    self.showingImagePicker = true
                }
                HStack {
                    Text("Intensity")
                    Slider(value: intensity)
                }.padding(.vertical)
                
                HStack {
                    Button("Change filter") {
                        //change filter
                        self.showingFilterSheet = true
                    }
                    Spacer()
                    Button("Save image") {
                        //save image
                        guard let processedImage = self.processedImage else { return }
                        
                        let imageSaver = ImageSaver()
                        imageSaver.sucessHandler = {
                            print("Success")
                        }
                        imageSaver.errorHandler = {
                            print("Oops \($0.localizedDescription)")
                        }
                        imageSaver.writeToPhotoAlbum(image: processedImage)
                    }
                }
            }
            .padding([.horizontal, .bottom])
            .navigationBarTitle(Text("InstaFilter"))
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
            .actionSheet(isPresented: $showingFilterSheet) {
                //action sheet here
                ActionSheet(title: Text("Select a filter"), buttons: [
                    .default(Text("Crystallize")) { self.setFilter(CIFilter.crystallize()) },
                    .default(Text("Edges")) { self.setFilter(CIFilter.edges()) },
                    .default(Text("Gaussian Blur")) { self.setFilter(CIFilter.gaussianBlur()) },
                    .default(Text("Pixellate")) { self.setFilter(CIFilter.pixellate()) },
                    .default(Text("Sepia Tone")) { self.setFilter(CIFilter.sepiaTone()) },
                    .default(Text("Unsharp Mask")) { self.setFilter(CIFilter.unsharpMask()) },
                    .default(Text("Vignette")) { self.setFilter(CIFilter.vignette()) },
                    .cancel()
                ])
            }
        }
    }
    
    //MARK: - Functions
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        //image = Image(uiImage: inputImage)
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func applyProcessing() {
//        currentFilter.intensity = Float(filterIntensity)
//        currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey) }
        
        guard let outputImage = currentFilter.outputImage else { return }
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiimage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiimage)
            processedImage = uiimage
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
