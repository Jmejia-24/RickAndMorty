//
//  Router.swift
//  RickAndMorty
//
//  Created by Byron Mejia on 3/7/23.
//

import UIKit

protocol Router: AnyObject {
    associatedtype Route
    var navigationController: UINavigationController { get set }
    func exit()
    func process(route: Route)
}

protocol AppRouter: Router where Route == AppTransition { }
