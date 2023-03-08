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
        List(viewModel.characters, id: \.self) { character in
            Text(character.name)
        }
        .listStyle(.plain)
        .onAppear {
            viewModel.fetchCharacters()
        }
    }
}
