//
//  MainViewModel.swift
//  RickAndMorty
//
//  Created by Byron Mejia on 3/8/23.
//

import UIKit
import Combine

protocol MainViewModelRepresentable: ObservableObject {
    var characters: [Character] { get }
    func fetchCharacters()
}

final class MainViewModel<R: AppRouter> {
    var router: R?
    
    private var cancellables = Set<AnyCancellable>()
    @Published private(set) var characters = [Character]()
}

extension MainViewModel: MainViewModelRepresentable {
    func fetchCharacters() {
        
        let recieved = { (response: CharacterResponse) -> Void in
            DispatchQueue.main.async { [unowned self] in
                characters = response.results
            }
        }
        
        let completion = { (completion: Subscribers.Completion<Error>) -> Void in
            switch  completion {
            case .finished:
                break
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
        
        APIManager.shared.execute(.listCharactersRequests)
            .sink(receiveCompletion: completion, receiveValue: recieved)
            .store(in: &cancellables)
    }
}
