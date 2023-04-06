//
//  CharacterInfoViewModel.swift
//  RickAndMortyMVVM+Combine
//
//  Created by  Егор Шуляк on 10.06.22.
//

import Foundation
import Combine
import UIKit

class CharacterInfoViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    @Published private(set) var state: State = .idle
    private let input = PassthroughSubject<Event, Never>()
    private let apiService: RickAndMortyApiProtocol
    private let characterId: Int
    
    enum State: Equatable {
        case idle
        case characterLoaded(character: CharacterInfo)
        case loading
        case failedWithError(error: String)
    }
    
    enum Event {
        case onAppear
        case characterLoaded(character: CharacterInfo)
        case characterLoadedWithError(Error)
    }
    
    init(characterId: Int, apiService: RickAndMortyApiProtocol) {
        self.apiService = apiService
        self.characterId = characterId
        Publishers.system(
            initial: state,
            reduce: reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                whenLoading(),
                userInput(input: input.eraseToAnyPublisher())
            ]
        )
        .assign(to: \.state, on: self)
        .store(in: &cancellables)
    }
    func send(event: Event) {
        input.send(event)
    }
    deinit {
        cancellables.removeAll()
    }
}

extension CharacterInfoViewModel {
    func reduce(_ state: State, _ event: Event) -> State {
        switch (state, event) {
        case (.idle, .onAppear):
            return .loading
        case (.loading, .characterLoaded(let character)):
            return .characterLoaded(character: character)
        case (.loading, .characterLoadedWithError(let error)):
            return .failedWithError(error: error.localizedDescription)
        default:
            return state
        }
    }
    
    func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
    
    func whenLoading() -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .loading = state else { return Empty().eraseToAnyPublisher() }
            return self.apiService.fetchCharacterInfo(characterId: self.characterId)
                .map { Event.characterLoaded(character: $0) }
                .catch { Just(Event.characterLoadedWithError($0)) }
                .eraseToAnyPublisher()
        }
    }
}
