//
//  CharacterListViewController.swift
//  RickAndMortyMVVM+Combine
//
//  Created by  Егор Шуляк on 9.06.22.
//

import UIKit
import Combine

class CharactersListViewController: UIViewController {
    
    private var subscriptions = Set<AnyCancellable>()
    private let viewModel: CharactersListViewModel
    private var dataSource: CellDataSource?
    private var characters: [CharacterForList] = []
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CharacterCell.self, forCellReuseIdentifier: CharacterCell.reuseID)
        tableView.delegate = self
        tableView.backgroundColor = .white
        return tableView
    }()
    
    init(viewModel: CharactersListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        subscriptions.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureDataSource()
        viewModel.sendEvent(event: .onAppear)
        
        setLayout()
        setBinding()
    }
    
    private func setBinding() {
        viewModel.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state{
                case .finished(let characters):
                    self?.characters.append(contentsOf: characters)
                    for character in characters {
                        self?.dataSource?.data.append(CellModel(character: character))
                    }
                    self?.tableView.tableFooterView = nil
                    self?.viewModel.state.send(.ready)
                case .inProcess:
                    self?.tableView.tableFooterView = self?.getSpinnerFooterView()
                case .loadedLastPage(let characters):
                    self?.characters.append(contentsOf: characters)
                    for character in characters {
                        self?.dataSource?.data.append(CellModel(character: character))
                    }
                    self?.tableView.tableFooterView = nil
                case .showsCharacterInfo(let vc):
                    self?.present(vc, animated: true)
                default:
                    break
                }
            }
            .store(in: &subscriptions)
    }
    
    private func configureDataSource() {
        dataSource = CellDataSource(tableView: tableView)
        tableView.dataSource = dataSource
    }
    
    private func setLayout() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension CharactersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        let characterId = characters[indexPath.row].id
        viewModel.sendEvent(event: .didSelectCharacter(id: characterId))
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isLastCell(indexPath: indexPath) {
            viewModel.sendEvent(event: .listIsEnded)
        }
    }
    
    private func getSpinnerFooterView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        let spinner = UIActivityIndicatorView()
        footerView.addSubview(spinner)
        spinner.center = footerView.center
        spinner.startAnimating()
        return footerView
    }
}
