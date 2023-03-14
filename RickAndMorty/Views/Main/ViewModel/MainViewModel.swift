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
    func convertOffsetToRotation(_ rect: CGRect) -> CGFloat
    func buttomPadding(_ size: CGSize) -> CGFloat
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
    
    func convertOffsetToRotation(_ rect: CGRect) -> CGFloat {
        let cellHeight = rect.height + 20
        let minY = rect.minY - 20
        let progress = minY < 0 ? (minY / cellHeight) : 0
        let constrainedProgress = min(-progress, 1.0)
        return constrainedProgress * 90
    }
    
    func buttomPadding(_ size: CGSize = .zero) -> CGFloat {
        let cellHeight: CGFloat = 200
        let scrollViewHeight: CGFloat = size.height
        
        return scrollViewHeight - cellHeight - 40
    }
}
