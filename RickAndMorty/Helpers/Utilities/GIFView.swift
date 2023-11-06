//
//  GIFView.swift
//  RickAndMorty
//
//  Created by Byron on 6/11/23.
//

import SwiftUI
import WebKit

struct GIFView: UIViewRepresentable {
    private let gifName: String

    public init(_ name: String) {
        self.gifName = name
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        guard let url = Bundle.main.url(forResource: gifName, withExtension: "gif"),
              let data = try? Data(contentsOf: url) else { return webView }

        webView.load(data, mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: url.deletingLastPathComponent())

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.reload()
    }
}
