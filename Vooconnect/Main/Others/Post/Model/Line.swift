//
//  Line.swift
//  Vooconnect
//
//  Created by Mac on 01/08/2023.
//

import Foundation
import SwiftUI

struct Line: Identifiable, Codable{
    var id = UUID()
    var points: [CGPoint]
    var lineWidth: CGFloat
    private var customColor: CustomColor
    var color: Color{
        get{
            customColor.color
        }
        set{
            customColor = CustomColor(color: newValue)
        }
    }
    
    init(points: [CGPoint], color: Color, lineWidth: CGFloat) {
        self.points = points
        self.lineWidth = lineWidth
        self.customColor = CustomColor(color: color)
        self.id = UUID()
    }
    
    
}


struct CustomColor: Codable{
    var red: Double = 0
    var green: Double = 0
    var blue: Double = 0
    var opacity: Double = 1
    
    init(color: Color) {
        if let components = color.cgColor?.components {
            if components.count > 2 {
                self.red = components[0]
                self.green = components[1]
                self.blue = components[2]
            }
            if components.count > 3 {
                self.opacity = components[3]
            }
        }
    }
    
    var color: Color{
        Color(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
