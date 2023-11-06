//
//  CacheImage.swift
//  RickAndMorty
//
//  Created by Byron Mejia on 3/14/23.
//

import SwiftUI

struct CacheImage<Placeholder>: View where Placeholder: View {

    @State private var image: Image?
    @State private var task: Task<(), Never>?
    @State private var isProgressing = false

    private let url: URL?
    private let placeholder: () -> Placeholder?

    init(url: URL?, @ViewBuilder placeholder: @escaping () -> Placeholder) {
        self.url = url
        self.placeholder = placeholder
    }

    init(url: URL?) where Placeholder == Color {
        self.init(url: url, placeholder: { Color(.systemGray2) })
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                placholderView
                imageView
                progressView
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .task {
                task?.cancel()
                task = Task.detached(priority: .background) {
                    await MainActor.run { isProgressing = true }

                    do {
                        let image = try await ImageCacheManager.shared.download(url: url)

                        await MainActor.run {
                            isProgressing = false
                            self.image = image
                        }
                    } catch {
                        await MainActor.run { isProgressing = false }
                    }
                }
            }
            .onDisappear {
                task?.cancel()
            }
        }
    }

    @ViewBuilder
    private var imageView: some View {
        if let image = image {
            image
                .resizable()
                .scaledToFill()
        }
    }

    @ViewBuilder
    private var placholderView: some View {
        if !isProgressing, image == nil {
            placeholder()
        }
    }

    @ViewBuilder
    private var progressView: some View {
        if isProgressing {
            ProgressView()
                .progressViewStyle(.circular)
        }
    }
}
