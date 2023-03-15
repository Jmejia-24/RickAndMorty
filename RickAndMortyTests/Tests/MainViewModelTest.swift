//
//  MainViewModelTest.swift
//  RickAndMortyTests
//
//  Created by Byron Mejia on 3/15/23.
//

import XCTest
import Combine

@testable import RickAndMorty

final class MainViewModelTest: XCTestCase {
    private var viewModel: MainViewModel<App>!
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = MainViewModel<App>(apiStore: APIManagerMock.shared)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        viewModel = nil
    }
    
    func testFetchCharacters() throws {
        let loadCharacters = XCTestExpectation(description: "Load Characters")
        var characters = [Character]()
        
        viewModel.$characters.dropFirst().sink { _ in
        } receiveValue: { response in
            characters = response
            loadCharacters.fulfill()
        }
        .store(in: &cancellables)
        
        viewModel.fetchCharacters()
        
        wait(for: [loadCharacters], timeout: 1)
        XCTAssertFalse(characters.isEmpty)
    }
}
