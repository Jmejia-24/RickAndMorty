//
//  ErrorView.swift
//  RickAndMorty
//
//  Created by Byron on 6/11/23.
//

import SwiftUI

struct ErrorView: View {
    let errorMessage: String
    let retryAction: () -> Void

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                Text("Oh, jeez!")
                    .font(.title)
                    .foregroundColor(.red)

                GIFView("ErrorImage")
                    .frame(width: geometry.size.width, height: geometry.size.width, alignment: .center)

                Text(errorMessage)
                    .font(.subheadline)
                    .foregroundColor(.black)

                Button {
                    retryAction()
                } label: {
                    Text("Retry")
                        .foregroundColor(.white)
                        .font(.callout)
                        .padding(8)

                }
                .background(.gray)
                .cornerRadius(8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .padding(20)
        .background(.white)
    }
}

#Preview {
    ErrorView(errorMessage: "Morty, Something went wrong in this dimension") {}
}
