//
//  MainCoordinator.swift
//  RickAndMorty
//
//  Created by Byron Mejia on 3/7/23.
//

import UIKit
import SwiftUI

final class MainCoordinator<R: AppRouter> {
    let router: R
    
    private lazy var primaryViewController: UIViewController = {
        let viewModel = MainViewModel<R>()
        viewModel.router = router
        let viewController = UIHostingController(rootView: MainView(viewModel: viewModel))
        return viewController
    }()
    
    init(router: R) {
        self.router = router
    }
}

extension MainCoordinator: Coordinator {
    func start() {
        router.navigationController.pushViewController(primaryViewController, animated: true)
    }
}
