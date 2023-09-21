//
//  CustomeCameraView.swift
//  Vooconnect
//
//  Created by Vooconnect on 05/12/22.
//

import SwiftUI
import AVFoundation

struct CustomeCameraView: View {
    
    @EnvironmentObject var cameraModel: CameraViewModel 
    
    var body: some View{
        
        GeometryReader{ proxy in
            let size = proxy.size
            
            CameraPreview(size: size)
                .environmentObject(cameraModel)
            
            ZStack(alignment: .leading) {
                
                
            }
            .frame(height: 8)
            .frame(maxHeight: .infinity,alignment: .top)
        }
        .padding(.bottom,-110)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .onAppear(perform: {
            if cameraModel.isBackCamera == false{
                self.cameraModel.checkPermission(isBackCamera: self.cameraModel.isBackCamera)
            }
        })
        .alert(isPresented: $cameraModel.alert) {
            Alert(title: Text("Please Enable cameraModel Access Or Microphone Access!!!"))
        }
    }
}

struct CustomeCameraView_Previews: PreviewProvider {
    static var previews: some View {
        CustomeCameraView()
    }
}


struct CameraPreview: UIViewRepresentable {
    
    @EnvironmentObject var cameraModel : CameraViewModel
    var size: CGSize
    let view = UIView()
    
    func makeUIView(context: Context) ->  UIView {
     
        
        
        DispatchQueue.main.async {  // change
            
            
            cameraModel.preview = AVCaptureVideoPreviewLayer(session: cameraModel.session)
            cameraModel.preview.frame.size = size
            
            cameraModel.preview.videoGravity = .resizeAspectFill
            view.layer.addSublayer(cameraModel.preview)
            
        }  // change
        
//        DispatchQueue.global(qos: .background).async { // change
        DispatchQueue.main.async {
            cameraModel.session.startRunning()
//        } // change
        }
            
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
