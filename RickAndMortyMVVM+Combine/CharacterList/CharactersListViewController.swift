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
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.dataSource = dataSource
        tableView.register(CharacterCell.self, forCellReuseIdentifier: CharacterCell.reuseID)
        return tableView
    }()
    
    init(viewModel: CharactersListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureDataSource()
        setLayout()
    }
    
    private func configureDataSource() {
        dataSource = CellDataSource(tableView: tableView)
        viewModel.charactersList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updateData in
                guard let self = self else { return }
                
                var snapshot = NSDiffableDataSourceSnapshot<Section, CharacterForList>()
                snapshot.appendSections([.main])
                snapshot.appendItems(updateData)
                self.dataSource?.apply(snapshot)
            }
            .store(in: &subscriptions)
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
        let characterId = viewModel.charactersList.value[indexPath.row].id
        let vc = CharacterInfoViewController(viewModel: CharacterInfoViewModel(characterId: characterId))
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
            viewModel.process
                .receive(on: DispatchQueue.main)
                .sink { process in
                    switch process {
                    case .ready:
                        if tableView.isLastCell(indexPath: indexPath) {
                            tableView.tableFooterView = self.getSpinnerFooterView()
                            let loadedPage = self.viewModel.loadedPage
                            self.viewModel.fetchCharactersList(page: loadedPage + 1)
                            self.viewModel.loadedPage += 1
                        }
                    case .finished:
                        self.tableView.tableFooterView = nil
                    case .finishedWithEmptyResult:
                        self.tableView.tableFooterView = nil
                    default:
                        break
                    }
                }
                .store(in: &subscriptions)
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
