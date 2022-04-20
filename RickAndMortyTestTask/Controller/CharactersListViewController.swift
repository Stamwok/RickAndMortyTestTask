//
//  ViewController.swift
//  RickAndMortyTestTask
//
//  Created by  Егор Шуляк on 17.04.22.
//

import UIKit
import SnapKit
import Kingfisher
import SkeletonView

final class CharactersListViewController: UIViewController {
    private var tableView = UITableView()
    private var apiManager: ApiProtocol
    private var dataSource = [CharacterForList]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - init
    init(api: ApiProtocol) {
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
            self?.dataSource.append(contentsOf: charactersList)
        }
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CharacterCell.self, forCellReuseIdentifier: CharacterCell.reuseID)
    }
}

// MARK: - tableView delegate
extension CharactersListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterCell.reuseID, for: indexPath) as? CharacterCell else {
            fatalError("wrong cell")
        }
        let dataForCell = dataSource[indexPath.row]
        cell.configureCell(name: dataForCell.name, species: dataForCell.species, gender: dataForCell.gender)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        
        let detailsViewController = CharacterDetailsViewController(characterID: dataSource[indexPath.row].id, api: apiManager)
        present(detailsViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? CharacterCell)?.downloadImageForCell(avatar: dataSource[indexPath.row].image)
        
        if tableView.isLastCell(indexPath: indexPath) {
            tableView.tableFooterView = getSpinnerFooterView()
            apiManager.getCharactersList(nextPage: true) { [weak self] charactersList in
                self?.dataSource.append(contentsOf: charactersList)
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
