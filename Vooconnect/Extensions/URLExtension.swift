//
//  URLExtension.swift
//  Vooconnect
//
//  Created by JV on 25/02/23.
//


import UIKit
import AVFoundation


extension URL {
    func asyncDownload(completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()) {
        URLSession.shared
            .dataTask(with: self, completionHandler: completion)
            .resume()
    }
}

extension UIImage {
    func rotate(by angle: CGFloat) -> UIImage? {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: angle))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            context.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
            context.rotate(by: angle)
            draw(in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return rotatedImage
        }
        return nil
    }
}
