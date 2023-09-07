//
//  DrawingShape.swift
//  Vooconnect
//
//  Created by Mac on 01/08/2023.
//

import SwiftUI

struct DrawingShape: Shape {
    let points: [CGPoint]
    let engine = DrawingEngine()
    func path(in rect: CGRect) -> Path {
        engine.createPath(for: points)
    }
}
