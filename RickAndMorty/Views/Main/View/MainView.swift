//
//  MainView.swift
//  RickAndMorty
//
//  Created by Byron Mejia on 3/8/23.
//

import SwiftUI

struct MainView<T>: View where T: MainViewModelRepresentable {
    @StateObject var viewModel: T
    @State var refresh: Bool = false

    var body: some View {
        GeometryReader {
            let size = $0.size
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 10) {
                    ForEach(viewModel.characters, id: \.self) {
                        characterCell($0)
                    }
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 20)
                .padding(.bottom, viewModel.buttomPadding(size))
            }
            .coordinateSpace(name: "SCROLLVIEW")
        }
        .padding(.top, 10)
        .onAppear {
            viewModel.fetchCharacters()
        }
    }

    @ViewBuilder func characterCell(_ character: Character) -> some View {
        GeometryReader {
            let size = $0.size
            let rect = $0.frame(in: .named("SCROLLVIEW"))

            HStack(spacing: -25) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(character.name)
                        .lineLimit(4)
                        .font(.system(size: 18))
                        .fontWeight(.semibold)

                    Text("Status: \(character.status.rawValue)")
                        .font(.caption)
                        .foregroundColor(.gray)

                    Spacer()

                    HStack(spacing: 5) {
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding(20)
                .frame(width: size.width / 2, height: size.height * 0.8)
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.white)
                        .shadow(color: .black.opacity(0.08), radius: 8, x: 5, y: 5)
                        .shadow(color: .black.opacity(0.08), radius: 8, x: -5, y: -5)
                }
                .zIndex(1)

                ZStack {
                    CacheImage(url: URL(string: character.image))
                        .clipShape(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                        )
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width / 2, height: size.height)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(width: size.width)
            .rotation3DEffect(
                .init(degrees: viewModel.convertOffsetToRotation(rect)),
                axis: (x: 1, y: 0, z: 0),
                anchor: .center,
                anchorZ: 1,
                perspective: 0.8
            )
        }
        .frame(height: 200)
    }
}
