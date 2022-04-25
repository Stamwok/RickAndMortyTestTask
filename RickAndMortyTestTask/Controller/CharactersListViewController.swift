//
//  ViewController.swift
//  RickAndMortyTestTask
//
//  Created by  Егор Шуляк on 17.04.22.
//

import UIKit
import Kingfisher

final class CharactersListViewController: UIViewController {
    private var tableView = UITableView()
    private var apiManager: ApiProtocol
    private var dataSource: CellDataSource?
    
    // MARK: - init
    init(api: ApiProtocol) {
        self.dataSource = CellDataSource(tableView: tableView)
        self.apiManager = api
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureTableView()
        apiManager.getCharactersList(nextPage: false) { [weak self] charactersList in
            self?.dataSource?.data.append(contentsOf: charactersList)
        }
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.register(CharacterCell.self, forCellReuseIdentifier: CharacterCell.reuseID)
    }
}

// MARK: - tableView delegate
extension CharactersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        
        let detailsViewController = CharacterDetailsViewController(characterID: dataSource?.data[indexPath.row].id ?? 0, api: apiManager)
        present(detailsViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? CharacterCell)?.downloadImageForCell(avatar: dataSource?.data[indexPath.row].image)
        
        if tableView.isLastCell(indexPath: indexPath), apiManager.isLastPage == false {
            tableView.tableFooterView = getSpinnerFooterView()
            apiManager.getCharactersList(nextPage: true) { [weak self] charactersList in
                self?.dataSource?.data.append(contentsOf: charactersList)
                self?.tableView.tableFooterView = nil
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? CharacterCell)?.downloadImageForCell(avatar: nil)
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
