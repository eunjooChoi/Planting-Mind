//
//  PrivacyPolicyWebview.swift
//  PlantingMind
//
//  Created by 최은주 on 4/13/24.
//

import SwiftUI
import WebKit
 
struct PrivacyPolicyWebview: UIViewRepresentable {
    var url: String
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: url) else {
            return WKWebView()
        }
        
        let webView = WKWebView()
        
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<PrivacyPolicyWebview>) { }
}
 
#Preview {
    PrivacyPolicyWebview(url: "https://www.naver.com")
}
