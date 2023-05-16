//
//  GifView.swift
//  GifView_SwiftUI
//
//  Created by Pedro Rojas on 16/08/21.
//

import SwiftUI
import WebKit

struct GifImage: UIViewRepresentable {
    private let name: String

    init(_ name: String) {
        self.name = name
//        UIView.appearance().backgroundColor = UIColor(named: "backgroundColor")
//        UIView.appearance().backgroundColor = UIColor(.clear)
        
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let url = Bundle.main.url(forResource: name, withExtension: "gif")!
        let data = try! Data(contentsOf: url)
        webView.load(
            data,
            mimeType: "image/gif",
            characterEncodingName: "UTF-8",
            baseURL: url.deletingLastPathComponent()
        )
        
        webView.scrollView.isScrollEnabled = false
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.reload()
            
    }

    
    
}


struct GifImage_Previews: PreviewProvider {
    static var previews: some View {
        GifImage("pokeball")
    }
}
