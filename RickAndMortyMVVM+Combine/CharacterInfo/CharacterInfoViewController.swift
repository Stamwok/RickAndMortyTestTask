//
//  CharacterInfoViewController.swift
//  RickAndMortyMVVM+Combine
//
//  Created by  Егор Шуляк on 10.06.22.
//

import UIKit
import Combine

class CharacterInfoViewController: UIViewController {
    
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let speciesLabel = UILabel()
    private let genderLabel = UILabel()
    private let statusLabel = UILabel()
    private let locationLabel = UILabel()
    private let episodesLabel = UILabel()
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let contentView = UIView()
    
    private let viewModel: CharacterInfoViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    init(viewModel: CharacterInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureViews()
        setBinding()
    }
    
    private func setBinding() {
    
        viewModel.avatar
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard let self = self else { return }
                self.avatarImageView.image = image
            }
            .store(in: &subscriptions)
        
        viewModel.name
            .receive(on: DispatchQueue.main)
            .sink { [weak self] name in
                guard let self = self else { return }
                self.nameLabel.text = name
            }
            .store(in: &subscriptions)
        
        viewModel.species
            .receive(on: DispatchQueue.main)
            .sink { [weak self] species in
                guard let self = self else { return }
                self.speciesLabel.text = "Species: \(species)"
            }
            .store(in: &subscriptions)
        
        viewModel.gender
            .receive(on: DispatchQueue.main)
            .sink { [weak self] gender in
                guard let self = self else { return }
                self.genderLabel.text = "Gender: \(gender)"
            }
            .store(in: &subscriptions)
        
        viewModel.status
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self = self else { return }
                self.statusLabel.text = "Status: \(status)"
            }
            .store(in: &subscriptions)
        
        viewModel.locationName
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                guard let self = self else { return }
                self.locationLabel.text = location
            }
            .store(in: &subscriptions)
        
        viewModel.episode
            .receive(on: DispatchQueue.main)
            .sink { [weak self] episode in
                guard let self = self else { return }
                self.episodesLabel.text = "Episodes: \(episode.count)"
            }
            .store(in: &subscriptions)
    }
    
    private func configureViews() {
        // configure scrollView
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // configure avatarImageView
        contentView.addSubview(avatarImageView)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30),
            avatarImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor)
        ])

        // configure nameLabel
        nameLabel.text = "text"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 25)
        nameLabel.textColor = .black
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: avatarImageView.leftAnchor),
            nameLabel.rightAnchor.constraint(equalTo: avatarImageView.rightAnchor),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 10)
        ])
        
        // configure locationLabel
        locationLabel.text = "text"
        locationLabel.font = UIFont.systemFont(ofSize: 15)
        locationLabel.textColor = .lightGray
        locationLabel.numberOfLines = 0
        locationLabel.textAlignment = .center
        contentView.addSubview(locationLabel)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            locationLabel.leftAnchor.constraint(equalTo: avatarImageView.leftAnchor),
            locationLabel.rightAnchor.constraint(equalTo: avatarImageView.rightAnchor),
            locationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10)
        ])
        
        // configure speciesLabel
        speciesLabel.text = "text"
        speciesLabel.font = UIFont.systemFont(ofSize: 17)
        speciesLabel.textColor = .black
        speciesLabel.numberOfLines = 0

        // configure genderLabel
        genderLabel.text = "text"
        genderLabel.font = UIFont.systemFont(ofSize: 17)
        genderLabel.textColor = .black
        genderLabel.numberOfLines = 0

        // configure statusLabel
        statusLabel.text = "text"
        statusLabel.font = UIFont.systemFont(ofSize: 17)
        statusLabel.textColor = .black
        statusLabel.numberOfLines = 0

        // configure episodesLabel
        episodesLabel.text = "text"
        episodesLabel.font = UIFont.systemFont(ofSize: 17)
        episodesLabel.textColor = .black
        episodesLabel.numberOfLines = 0

        // configure stackView
        stackView.axis = .vertical
        stackView.contentMode = .left
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: avatarImageView.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: avatarImageView.rightAnchor),
            stackView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 15),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        stackView.addArrangedSubview(speciesLabel)
        stackView.addArrangedSubview(genderLabel)
        stackView.addArrangedSubview(statusLabel)
        stackView.addArrangedSubview(episodesLabel)
    }
}
