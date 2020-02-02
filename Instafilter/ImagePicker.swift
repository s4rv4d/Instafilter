//
//  ImagePicker.swift
//  Instafilter
//
//  Created by Sarvad shetty on 2/1/20.
//  Copyright © 2020 Sarvad shetty. All rights reserved.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {    
    //coordinator class
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent:ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiimage = info[.originalImage] as? UIImage {
                parent.image = uiimage
            }
            //then dismiss after selecting
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    //lets us detect if image was selected in contentView.swift
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
}
