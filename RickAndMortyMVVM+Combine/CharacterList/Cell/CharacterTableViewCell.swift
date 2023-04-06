//
//  CharacterCell.swift
//  RickAndMortyTestTask
//
//  Created by  Егор Шуляк on 19.04.22.
//

import UIKit
import CollectionAndTableViewCompatible
import Combine
import Kingfisher

final class CharacterTableViewCell: UITableViewCell, Configurable {
    static let reuseID = String(describing: CharacterTableViewCell.self)
    
    private var avatarImageView = UIImageView()
    private var nameLabel = UILabel()
    private var speciesLabel = UILabel()
    private var genderLabel = UILabel()
    
    var model: CharacterTableCellModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
        layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.clipsToBounds = true
    }
    
    func configure(withModel model: CharacterTableCellModel) {
        self.model = model
        self.avatarImageView.kf.setImage(with: URL(string: model.avatar))
        self.nameLabel.text = model.name
        self.genderLabel.text = model.gender
        self.speciesLabel.text = model.species
    }
    
    
    private func configureViews() {
        // configure imageView
        contentView.addSubview(avatarImageView)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50)
        ])
        avatarImageView.backgroundColor = .lightGray
        
        // configure nameLabel
        nameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        nameLabel.text = " "
        nameLabel.textColor = .black
        nameLabel.numberOfLines = 0
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 5),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5)
        ])
        
        // configure speciesLabel
        speciesLabel.font = UIFont.systemFont(ofSize: 13)
        speciesLabel.text = " "
        speciesLabel.textColor = .lightGray
        speciesLabel.numberOfLines = 1
        contentView.addSubview(speciesLabel)
        speciesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            speciesLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 5),
            speciesLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            speciesLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5)
        ])
        
        // configure genderLabel
        genderLabel.font = UIFont.systemFont(ofSize: 13)
        genderLabel.text = " "
        genderLabel.textColor = .lightGray
        genderLabel.numberOfLines = 1
        contentView.addSubview(genderLabel)
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            genderLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 5),
            genderLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            genderLabel.topAnchor.constraint(equalTo: speciesLabel.bottomAnchor, constant: 5),
            genderLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
}