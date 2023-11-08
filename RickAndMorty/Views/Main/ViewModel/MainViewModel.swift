//
//  MainViewModel.swift
//  RickAndMorty
//
//  Created by Byron Mejia on 3/8/23.
//

import UIKit
import Combine

protocol MainViewModelRepresentable: ObservableObject {
    var state: ViewState<[Character]> { get }
    func fetchCharacters()
    func fetchMoreCharacters(currentItem character: Character?)
    func convertOffsetToRotation(_ rect: CGRect) -> CGFloat
    func buttomPadding(_ size: CGSize) -> CGFloat
}

final class MainViewModel<R: AppRouter> {
    var router: R?
    private let apiStore: APIManagerStore

    private var charactersCancellables = Set<AnyCancellable>()
    private var moreCharactersCancellables = Set<AnyCancellable>()

    private var isLoadingMoreCharacters = false
    private var apiInfo: CharacterResponse.Info?

    @Published var state: ViewState<[Character]> = .loading
    @Published var characters: [Character] = []

    init(apiStore: APIManagerStore = APIManager.shared) {
        self.apiStore = apiStore
    }
}

extension MainViewModel: MainViewModelRepresentable {
    func fetchCharacters() {
        state = .loading

        let recieved = { (response: CharacterResponse) -> Void in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }

                self.characters = response.results
                self.apiInfo = response.info

                state = .success(self.characters)
            }
        }

        let completion = { (completion: Subscribers.Completion<Error>) -> Void in
            switch  completion {
            case .finished:
                break
            case .failure(let failure):
                DispatchQueue.main.async { [unowned self] in
                    state = .error(failure.localizedDescription)
                }
            }
        }

        apiStore.execute(.listCharactersRequests)
            .sink(receiveCompletion: completion, receiveValue: recieved)
            .store(in: &charactersCancellables)
    }

    func fetchMoreCharacters(currentItem character: Character?) {
        let thresholdIndex = characters.index(characters.endIndex, offsetBy: -5)

        guard let character = character,
              !isLoadingMoreCharacters,
              let nextPage = apiInfo?.next,
              let url = URL(string: nextPage),
              let request = Request(url: url),
              characters.firstIndex(where: { $0.id == character.id }) == thresholdIndex else {
            isLoadingMoreCharacters = false
            return
        }

        isLoadingMoreCharacters = true

        let recieved = { (response: CharacterResponse) -> Void in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }

                self.apiInfo = response.info
                self.characters.append(contentsOf: response.results)
                isLoadingMoreCharacters = false

                state = .success(self.characters)
            }
        }

        let completion = { [weak self] (completion: Subscribers.Completion<Error>) -> Void in
            guard let self else { return }

            switch completion {
            case .finished:
                break
            case .failure:
                self.isLoadingMoreCharacters = false
            }
        }

        apiStore.execute(request)
            .sink(receiveCompletion: completion, receiveValue: recieved)
            .store(in: &moreCharactersCancellables)
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
