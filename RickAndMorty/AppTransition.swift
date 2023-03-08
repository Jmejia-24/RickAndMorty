//
//  AppTransition.swift
//  RickAndMorty
//
//  Created by Byron Mejia on 3/7/23.
//

import Foundation

enum AppTransition {
    
    case showMainScreen
    
    var hasState: Bool {
        /// If some transitions need to have state - perform case match logic here
        /// Generally prefer stateless
        false
    }
    
    func coordinatorFor<R: AppRouter>(router: R) -> Coordinator {
        switch self {
        case .showMainScreen: return MainCoordinator(router: router)
        }
    }
}

extension AppTransition: Hashable {
    
    var identifier: String {
        switch self {
        case .showMainScreen: return "showMainScreen"
        }
    }
    
    static func == (lhs: AppTransition, rhs: AppTransition) -> Bool {
        lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
