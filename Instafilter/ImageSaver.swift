//
//  ImageSaver.swift
//  Instafilter
//
//  Created by Sarvad shetty on 2/2/20.
//  Copyright © 2020 Sarvad shetty. All rights reserved.
//

import UIKit

class ImageSaver: NSObject {
    
    var sucessHandler: (() -> Void)?
    var errorHandler: ((Error) -> Void)?
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }
    
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            errorHandler?(error)
        } else {
            sucessHandler?()
        }
    }
}
