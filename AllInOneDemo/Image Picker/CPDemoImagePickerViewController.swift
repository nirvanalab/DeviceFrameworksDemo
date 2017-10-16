//
//  CPDemoImagePickerViewController.swift
//  AllInOneDemo
//
//  Created by Nirvana on 10/14/17.
//  Copyright © 2017 Nirvana. All rights reserved.
//

import UIKit

class CPDemoImagePickerViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func onPhotoLibraryPressed(_ sender: Any) {
        
        let photoVC = UIImagePickerController()
        photoVC.delegate = self
        photoVC.allowsEditing = true
        photoVC.sourceType = .photoLibrary
        
        self.present(photoVC, animated: true) {
            //do something custom here
        }
        
    }
    

    @IBAction func onCameraPressed(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraVC = UIImagePickerController()
            cameraVC.delegate = self
            cameraVC.allowsEditing = true
            cameraVC.sourceType = .camera
            cameraVC.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
            cameraVC.cameraFlashMode = .on
            cameraVC.cameraDevice = .front
            
//            let overlayView = UIView.init(frame: cameraVC.view.frame)
//            overlayView.backgroundColor = UIColor.green
//            overlayView.alpha = 0.5
//            overlayView.isOpaque = false
//            cameraVC.cameraOverlayView = overlayView
            
            //cameraVC.
            self.present(cameraVC, animated: true) {
                //do something custom here
                /*UIView.animate(withDuration: 0.5, animations: {
                    cameraVC.cameraViewTransform = CGAffineTransform.init(rotationAngle: -3.14  )
                })*/
            }
        }
     }
    
}

extension CPDemoImagePickerViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        self.imageView.image = originalImage
        
        dismiss(animated: true, completion: nil)
    }
}
