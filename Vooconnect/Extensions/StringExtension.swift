//
//  StringExtension.swift
//  Vooconnect
//
//  Created by JV on 24/03/23.
//

import UIKit

extension String {
    func image() -> UIImage? {
        let size = CGSize(width: 40, height: 40)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 35)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
        
        func localized() -> String {
            return NSLocalizedString(self, comment: "")
        }
        
        func appendLanguageCode() -> String {
            
            var code = ""
            if #available(iOS 10.0, *) {
                code = Locale.current.language.languageCode?.identifier.lowercased() ?? ""
            } else {
                code = Locale.preferredLanguages[0].prefix(2).lowercased()
            }
            
            var resultString = self
            if code == "ko" {
                resultString.append(code)
            } else {
                resultString.append("en")
            }
            
            return resultString
        }

}
