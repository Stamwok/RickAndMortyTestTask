//
//  DetailsViewController.swift
//  RickAndMortyTestTask
//
//  Created by  Егор Шуляк on 19.04.22.
//

import UIKit
import SnapKit
import Kingfisher
import SkeletonView

final class CharacterDetailsViewController: UIViewController {
    private var avatarImageView = UIImageView()
    private var nameLabel = UILabel()
    private var speciesLabel = UILabel()
    private var genderLabel = UILabel()
    private var statusLabel = UILabel()
    private var locationLabel = UILabel()
    private var episodesLabel = UILabel()
    private var scrollView = UIScrollView()
    private var stackView = UIStackView()
    
    private var characterID: Int
    private var apiManager: ApiProtocol

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureViews()
        
        avatarImageView.isSkeletonable = true
        locationLabel.isSkeletonable = true
        nameLabel.isSkeletonable = true
        stackView.isSkeletonable = true
        scrollView.isSkeletonable = true
        scrollView.showSkeleton(transition: .crossDissolve(0.25))
        
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
            with: URL(string: character.image)) { [weak self] _ in
                self?.scrollView.hideSkeleton(transition: .crossDissolve(0.25))
            }
        nameLabel.text = character.name
        locationLabel.text = character.location.name
        speciesLabel.text = "Species: \(character.species)"
        genderLabel.text = "Gender: \(character.gender)"
        statusLabel.text = "Status: \(character.status)"
        episodesLabel.text = "Episodes: \(character.episode.count)"
    }
    
    private func configureViews() {
        // configure scrollView
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // configure avatarImageView
        scrollView.addSubview(avatarImageView)
//        avatarImageView.backgroundColor = .lightGray
        avatarImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(30)
            make.centerX.equalToSuperview()
            make.right.equalToSuperview().inset(30)
            make.left.equalToSuperview().inset(30)
            make.height.equalTo(avatarImageView.snp.width)
        }
        
        // configure nameLabel
        nameLabel.text = "text"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 25)
        nameLabel.textColor = .black
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        scrollView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(10)
            make.left.equalTo(avatarImageView)
            make.right.equalTo(avatarImageView)
        }
        
        // configure locationLabel
        locationLabel.text = "text"
        locationLabel.font = UIFont.systemFont(ofSize: 15)
//        locationLabel.textColor = .lightGray
        locationLabel.numberOfLines = 0
        locationLabel.textAlignment = .center
        scrollView.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.left.equalTo(avatarImageView)
            make.right.equalTo(avatarImageView)
        }
        
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
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(15)
            make.left.equalTo(avatarImageView)
            make.right.equalTo(avatarImageView)
            make.bottom.equalTo(10)
        }
        stackView.addArrangedSubview(speciesLabel)
        stackView.addArrangedSubview(genderLabel)
        stackView.addArrangedSubview(statusLabel)
        stackView.addArrangedSubview(episodesLabel)
    }
}
