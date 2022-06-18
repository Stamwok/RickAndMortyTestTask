//
//  CharacterInfoTests.swift
//  CharacterInfoTests
//
//  Created by  Егор Шуляк on 17.06.22.
//

import XCTest
@testable import RickAndMortyMVVM_Combine

class CharacterInfoTests: XCTestCase {

    var apiService: MockApiService!
    var viewModel: CharacterInfoViewModel!
    
    override func setUp() {
        super.setUp()
        apiService = MockApiService()
        viewModel = CharacterInfoViewModel(characterId: 1, apiService: apiService)
    }
    
    override func tearDown() {
        viewModel = nil
        apiService = nil
        super.tearDown()
    }
    
    func testInitViewModel() {
        XCTAssertEqual(viewModel.state.value, .idle)
    }
    
    func testOnAppear() {
        apiService.fetchCharacterInfoSuccess()
        viewModel.sendEvent(event: .onAppear)
        XCTAssertEqual(viewModel.state.value, .loading)
        sleep(1)
        let someCharacter = CharacterInfo(id: 1, name: "", species: "", gender: "", image: "", status: "", location: Location(name: "", url: ""), episode: [String]())
        XCTAssertEqual(viewModel.state.value, .characterLoaded(character: someCharacter))
    }
    
    func testFinishedWithError() {
        apiService.fetchCharacterInfoFailure()
        viewModel.sendEvent(event: .onAppear)
        XCTAssertEqual(viewModel.state.value, .loading)
        sleep(1)
        let someError = NSError(domain: "", code: 401, userInfo: [ NSLocalizedDescriptionKey: "Some error"])
        XCTAssertEqual(self.viewModel.state.value, .failedWithError(error: someError))
    }
}
