//
//  ShutterView.swift
//  ARGearSample
//
//  Created by Jihye on 2020/01/30.
//  Copyright © 2020 Seerslab. All rights reserved.
//

import UIKit
import ARGear

class ShutterView: UIView {
    var mode: ARGMediaMode = .photo
    @IBOutlet var cameraImg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setShutterMode(_ mode: ARGMediaMode) {
        switch mode {
        case .photo:
            self.setPhotoMode()
        case .video:
            self.setVideoMode()
        default:
            return
        }
    }
    
    func setPhotoMode() {
        self.mode = .photo
        // Set Image
        cameraImg.image = UIImage(named: "CameraClick")
    }
    
    func setVideoMode() {
        self.mode = .video
        // SetImage
        cameraImg.image = UIImage(named: "CameraRecording")
    }
}
