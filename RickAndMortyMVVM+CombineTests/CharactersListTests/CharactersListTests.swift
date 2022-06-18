//
//  RickAndMortyMVVM_CombineTests.swift
//  RickAndMortyMVVM+CombineTests
//
//  Created by  Егор Шуляк on 17.06.22.
//

import XCTest
import Combine
@testable import RickAndMortyMVVM_Combine

class RickAndMortyMVVM_CombineTests: XCTestCase {
    var apiService: MockApiService!
    var viewModel: CharactersListViewModel!
    
    override func setUp() {
        super.setUp()
        apiService = MockApiService()
        viewModel = CharactersListViewModel(apiService: apiService)
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
        apiService.fetchCaractersListSuccess()
        viewModel.sendEvent(event: .onAppear)
        XCTAssertEqual(viewModel.state.value, .loading)
        sleep(1)
        XCTAssertEqual(viewModel.state.value, .loaded(hasNext: true))
        XCTAssertEqual(viewModel.data.count, 20)
    }
    
    func testFinishedWithError() {
        apiService.fetchCharactersListFailure()
        viewModel.sendEvent(event: .onAppear)
        XCTAssertEqual(viewModel.state.value, .loading)
        sleep(1)
        let someError = NSError(domain: "", code: 401, userInfo: [ NSLocalizedDescriptionKey: "Some error"])
        XCTAssertEqual(self.viewModel.state.value, .failedWithError(error: someError))
        XCTAssertEqual(viewModel.data.count, 0)
    }
    
    func testListIsEnded() {
        apiService.fetchCaractersListSuccess()
        viewModel.sendEvent(event: .onAppear)
        XCTAssertEqual(viewModel.state.value, .loading)
        sleep(1)
        XCTAssertEqual(viewModel.state.value, .loaded(hasNext: true))
        XCTAssertEqual(viewModel.data.count, 20)
        
        viewModel.sendEvent(event: .listIsEnded)
        XCTAssertEqual(viewModel.state.value, .loading)
        sleep(1)
        XCTAssertEqual(viewModel.state.value, .loaded(hasNext: true))
        XCTAssertEqual(viewModel.data.count, 40)
    }
    
    func testLoadedLastPage() {
        apiService.fetchLastPage()
        viewModel.sendEvent(event: .onAppear)
        XCTAssertEqual(viewModel.state.value, .loading)
        sleep(1)
        XCTAssertEqual(viewModel.state.value, .loaded(hasNext: false))
        XCTAssertEqual(viewModel.data.count, 20)
        viewModel.sendEvent(event: .listIsEnded)
        XCTAssertEqual(viewModel.state.value, .loaded(hasNext: false))
        XCTAssertEqual(viewModel.data.count, 20)
    }
    
    func testFetchWhenLoading() {
        apiService.fetchCaractersListSuccess()
        viewModel.sendEvent(event: .onAppear)
        viewModel.sendEvent(event: .listIsEnded)
        XCTAssertEqual(viewModel.state.value, .loading)
        sleep(1)
        XCTAssertEqual(viewModel.state.value, .loaded(hasNext: true))
        XCTAssertEqual(viewModel.data.count, 20)
    }
}


