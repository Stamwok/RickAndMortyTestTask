//
//  CharactersListViewModel.swift
//  RickAndMortyMVVM+Combine
//
//  Created by  Егор Шуляк on 9.06.22.
//

import Foundation
import Combine
import CollectionAndTableViewCompatible

class CharactersListViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event, Never>()
    
    private(set) var data = [CharacterTableCellModel]()
    private let apiService: RickAndMortyApiProtocol
    
    var showCharacterInfo: ((Int) -> Void)?
    
    enum Event {
        case onAppear
        case onCharactersLoaded([CharacterTableCellModel], nextPage: String?)
        case onFailedToLoadedCharacters(Error)
        case didSelectCharacter(row: Int)
        case loadMoreCharacters
    }
    
    enum State: Equatable {
        case idle
        case loading
        case loaded(items: [CharacterTableCellModel], nextPage: String?)
        case loadedWithError(error: String)
    }
    
    
    private var currentPage = 1
    @Published private(set) var state: State = .idle
    
    init(apiService: RickAndMortyApiProtocol) {
        self.apiService = apiService
        
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
    deinit {
        cancellables.removeAll()
    }
    
    func send(event: Event) {
        input.send(event)
    }
}

extension CharactersListViewModel {
    func reduce(_ state: State, _ event: Event) -> State {
        switch (state, event) {
        case (.idle, .onAppear):
            return .loading
        case (.loading, .onCharactersLoaded(let items, let nextPage)):
            self.data.append(contentsOf: items)
            return .loaded(items: items, nextPage: nextPage)
        case (.loading, .onFailedToLoadedCharacters(let error)):
            return .loadedWithError(error: error.localizedDescription)
        case (.loaded(_, let nextPage), .loadMoreCharacters):
            if nextPage != nil {
                return .loading
            } else {
                return state
            }
        case (_, .didSelectCharacter(let row)):
            showCharacterInfo?(self.data[row].character.id)
            return state
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
            self.currentPage += 1
            return self.apiService.fetchCharactersList(page: self.currentPage)
                .map { response in
                    let items = response.results.map { CharacterTableCellModel(character: $0) }
                    let nextPage = response.info.next
                    return Event.onCharactersLoaded(items, nextPage: nextPage)
                }
                .catch { Just(Event.onFailedToLoadedCharacters($0)) }
                .eraseToAnyPublisher()
        }
    }
}
