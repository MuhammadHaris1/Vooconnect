//
//  DrawingDocument.swift
//  Vooconnect
//
//  Created by Mac on 01/08/2023.
//

import Foundation

class DrawingDocument: ObservableObject{
    @Published var lines = [Line]()
    
    
    init(){
        if FileManager.default.fileExists(atPath: url.path),
           let data = try? Data(contentsOf: url){
            let decoder = JSONDecoder()
            do {
                let lines = try decoder.decode([Line].self, from: data)
                self.lines = lines
            } catch{
                print("error decoding \(error.localizedDescription)")
            }
        }
        
    }
    
    func save(){
        
        let encoder = JSONEncoder()
        
        let data = try? encoder.encode(lines)
        
        do{
            try data?.write(to: url)
        }catch{
            print("error Encoding \(error.localizedDescription)")
        }
    }
    
    var url: URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = path[0]
        return documentDirectory.appendingPathComponent("Document").appendingPathExtension("json")
    }
}
