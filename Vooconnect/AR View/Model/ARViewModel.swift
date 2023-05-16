//
//  ARViewModel.swift
//  Vooconnect
//
//  Created by JV on 4/03/23.
//

import Foundation
import RealityKit
import ARKit

class ARViewModel: UIViewController, ObservableObject, ARSessionDelegate {
    @Published private var model : ARModel = ARModel()
    
    var arView : ARView {
        model.arView
    }
    
//    var isSmiling: Bool {
//        var temp = false
//        if model.smileLeft > 0.3 || model.smileRight > 0.3 {
//            temp = true
//        }
//        return temp
//    }
    
    func startSessionDelegate() {
        model.arView.session.delegate = self
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        if let faceAnchor = anchors.first  as? ARFaceAnchor {
            model.update(faceAnchor: faceAnchor)
        }
    }
    
    func setArView(_ type : TypeOfARView){
        model.setTypeOfAr(type)
    }
    
}
