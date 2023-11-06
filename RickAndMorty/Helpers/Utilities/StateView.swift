//
//  StateView.swift
//  RickAndMorty
//
//  Created by Byron on 6/11/23.
//

import SwiftUI

enum ViewState<Value> {
    case loading
    case success(Value)
    case error(String)
}

struct StateView<Value, Content>: View where Content: View {
    var state: ViewState<Value>
    let content: (Value) -> Content
    let retryAction: () -> Void

    var body: some View {
        switch state {
        case .loading:
            return AnyView(
                GIFView("LoadingImage")
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width, alignment: .center)
            )
        case .success(let value):
            return AnyView(content(value))
        case .error:
            return AnyView(
                ErrorView(errorMessage: "Morty, Something went wrong in this dimension") {
                    retryAction()
                }
            )
        }
    }
}
