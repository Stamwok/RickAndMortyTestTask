//
//  DetailsViewController.swift
//  RickAndMortyTestTask
//
//  Created by  Егор Шуляк on 19.04.22.
//

import UIKit
import Kingfisher
import SkeletonView

final class CharacterDetailsViewController: UIViewController {
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
    
    private var characterID: Int
    private var apiManager: ApiProtocol

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureViews()
        view.layoutIfNeeded()
        avatarImageView.isSkeletonable = true
        locationLabel.isSkeletonable = true
        nameLabel.isSkeletonable = true
        stackView.isSkeletonable = true
        contentView.isSkeletonable = true
        contentView.showSkeleton()
        
        apiManager.getDetailInfo(id: characterID) { [weak self] character in
            self?.setData(character: character)
        }
    }
    
    init(characterID: Int, api: ApiProtocol) {
        self.characterID = characterID
        self.apiManager = api
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setData(character: CharacterForDetailScreen) {
        avatarImageView.kf.setImage(
            with: URL(string: character.image ?? "")) { [weak self] _ in
                self?.contentView.hideSkeleton()
            }
        nameLabel.text = character.name
        locationLabel.text = character.location?.name
        speciesLabel.text = "Species: \(character.species ?? "")"
        genderLabel.text = "Gender: \(character.gender ?? "")"
        statusLabel.text = "Status: \(character.status ?? "")"
        episodesLabel.text = "Episodes: \(character.episode?.count ?? 0)"
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
