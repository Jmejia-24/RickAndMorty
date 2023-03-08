//
//  MainViewModel.swift
//  RickAndMorty
//
//  Created by Byron Mejia on 3/8/23.
//

import UIKit

protocol MainViewModelRepresentable {
}

final class MainViewModel<R: AppRouter> {
    var router: R?
}

extension MainViewModel: MainViewModelRepresentable {
}
