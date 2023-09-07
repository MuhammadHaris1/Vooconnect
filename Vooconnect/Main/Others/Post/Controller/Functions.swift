
import SwiftUI
import Photos
import AVKit
import AVFoundation

func downloadAndSaveWithCaptionVideo(){
    var fileName = UserDefaults.standard.string(forKey: "imageName") ?? ""
    let markedVideoURL = URL(string: getImageVideoMarkedBaseURL + fileName)
    print(markedVideoURL!)
    let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    let destinationUrl = docsUrl?.appendingPathComponent(markedVideoURL?.lastPathComponent ?? "")
    
    if let destinationUrl = destinationUrl {
        if FileManager().fileExists(atPath: destinationUrl.path) {
            print("File already exists")
            try! FileManager().removeItem(atPath: destinationUrl.path)
            saveVideo(url: markedVideoURL!, destiURL: destinationUrl)
        } else {
            saveVideo(url: markedVideoURL!, destiURL: destinationUrl)
//            try! FileManager().removeItem(atPath: destinationUrl.path)
        }
    }
}

func downloadAncdSaveVideo(){
    var fileName = UserDefaults.standard.string(forKey: "imageName") ?? ""
    let markedVideoURL = URL(string: getImageVideoMarkedBaseURL + "/marked" + fileName)
    print(markedVideoURL!)
    let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    let destinationUrl = docsUrl?.appendingPathComponent(markedVideoURL?.lastPathComponent ?? "")
    
    if let destinationUrl = destinationUrl {
        if FileManager().fileExists(atPath: destinationUrl.path) {
            print("File already exists")
            try! FileManager().removeItem(atPath: destinationUrl.path)
            saveVideo(url: markedVideoURL!, destiURL: destinationUrl)
        } else {
            saveVideo(url: markedVideoURL!, destiURL: destinationUrl)
//            try! FileManager().removeItem(atPath: destinationUrl.path)
        }
    }
}

func saveVideo(url: URL, destiURL: URL) {
    let urlRequest = URLRequest(url: url)
    
    let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
        if let error = error {
            print("Request error: ", error)
            
            //                                                          self.isDownloading = false
            return
        }
        
        guard let response = response as? HTTPURLResponse else { return }
        
        if response.statusCode == 200 {
            guard let data = data else {
                //                                                              self.isDownloading = false
                return
            }
            DispatchQueue.main.async {
                do {
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: destiURL)
                    }) { saved, error in
                        if saved {
                            print("saved")
                            //
                        }else{
                            debugPrint(error)
                        }
                    }
                    try data.write(to: destiURL, options: Data.WritingOptions.atomic)
                    DispatchQueue.main.async {
                        //                                                                      self.isDownloading = false
                    }
                } catch let error {
                    print("Error decoding: ", error)
                    //                                                                  self.isDownloading = false
                }
            }
        }
    }
    dataTask.resume()
}
