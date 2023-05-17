//
//  CharacterListViewController.swift
//  RickAndMortyMVVM+Combine
//
//  Created by  Егор Шуляк on 9.06.22.
//

import UIKit
import Combine
import RouteComposer

class CharactersListViewControllerFactory: Factory {
    typealias ViewController = CharactersListViewController
    
    typealias Context = CharactersListViewModel
    
    func build(with viewModel: Context) throws -> CharactersListViewController {
        let controller = CharactersListViewController()
        controller.viewModel = viewModel
        return controller
    }
}

class CharactersListViewController: UIViewController {
    
    private var subscriptions = Set<AnyCancellable>()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: CharacterTableViewCell.reuseID)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        return tableView
    }()
    
    var viewModel: CharactersListViewModel? {
        didSet {
            guard let viewModel else { return }
            setBinding(viewModel: viewModel)
        }
    }
    
//    init(viewModel: CharactersListViewModel) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Characters list"
        viewModel?.send(event: .onAppear)
        
        setLayout()
    }
    
    private func setBinding(viewModel: CharactersListViewModel) {
        viewModel.showCharacterInfo = { [weak self] viewModel in
//            router.navigate(to: StepAssembly(finder: <#T##Finder#>, factory: <#T##ContainerFactory#>))
//            try? router.navigate(to: StepAssembly(finder: <#T##_#>, factory: <#T##_#>))
        }
        
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .loaded:
                    self?.tableView.reloadData()
                    self?.tableView.tableFooterView = nil
                case .loading:
                    self?.tableView.tableFooterView = self?.getSpinnerFooterView()
                default:
                    break
                }
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
        viewModel?.send(event: .didSelectCharacter(row: indexPath.row))
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isLastCell(indexPath: indexPath) {
            viewModel?.send(event: .loadMoreCharacters)
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

extension CharactersListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel else { return UITableViewCell() }
        let cellModel = viewModel.data[indexPath.row]
        return cellModel.cellForTableView(tableView: tableView, atIndexPath: indexPath)
    }
}
