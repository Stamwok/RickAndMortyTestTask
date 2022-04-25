//
//  CharacterCell.swift
//  RickAndMortyTestTask
//
//  Created by  Егор Шуляк on 19.04.22.
//

import UIKit
import Kingfisher
import CollectionAndTableViewCompatible

final class CharacterCell: UITableViewCell, Configurable {
    static let reuseID = String(describing: CharacterCell.self)
    
    private var avatarImageView = UIImageView()
    private var nameLabel = UILabel()
    private var speciesLabel = UILabel()
    private var genderLabel = UILabel()
    
    var model: CellModel?
    
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
    
    func configure(withModel model: CellModel) {
        self.model = model
        guard let dataForCell = self.model?.character else { return }
        nameLabel.text = dataForCell.name
        speciesLabel.text = dataForCell.species
        genderLabel.text = dataForCell.gender
    }
    
    private func configureViews() {
        // configure imageView
        contentView.addSubview(avatarImageView)
//        avatarImageView.snp.makeConstraints { make in
//            make.left.equalToSuperview().inset(5)
//            make.centerY.equalToSuperview()
//            make.height.equalTo(50)
//            make.width.equalTo(avatarImageView.snp.height)
//        }
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
//            avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50)
        ])
        avatarImageView.backgroundColor = .clouds
        
        // configure nameLabel
        nameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        nameLabel.textColor = .black
        nameLabel.numberOfLines = 0
        contentView.addSubview(nameLabel)
//        nameLabel.snp.makeConstraints { make in
//            make.left.equalTo(avatarImageView.snp.right).offset(5)
//            make.top.equalToSuperview().inset(5)
//            make.right.equalToSuperview().inset(5)
//        }
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 5),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 5),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5)
        ])
        
        // configure speciesLabel
        speciesLabel.font = UIFont.systemFont(ofSize: 13)
        speciesLabel.textColor = .lightGray
        speciesLabel.numberOfLines = 1
        contentView.addSubview(speciesLabel)
//        speciesLabel.snp.makeConstraints { make in
//            make.left.equalTo(avatarImageView.snp.right).offset(5)
//            make.right.equalToSuperview().inset(5)
//            make.top.equalTo(nameLabel.snp.bottom).offset(5)
//        }
        speciesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            speciesLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 5),
            speciesLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            speciesLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5)
        ])
        
        // configure genderLabel
        genderLabel.font = UIFont.systemFont(ofSize: 13)
        genderLabel.textColor = .lightGray
        genderLabel.numberOfLines = 1
        contentView.addSubview(genderLabel)
//        genderLabel.snp.makeConstraints { make in
//            make.left.equalTo(avatarImageView.snp.right).offset(5)
//            make.right.equalToSuperview().inset(5)
//            make.top.equalTo(speciesLabel.snp.bottom).offset(5)
//            make.bottom.equalToSuperview().inset(5)
//        }
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            genderLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 5),
            genderLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 5),
            genderLabel.topAnchor.constraint(equalTo: speciesLabel.bottomAnchor, constant: 5),
            genderLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
    func downloadImageForCell(avatar: String?) {
        if let urlString = avatar, let url = URL(string: urlString) {
            let processor = DownsamplingImageProcessor(size: avatarImageView.bounds.size)
            avatarImageView.kf.setImage(
                with: url,
                options: [
                    .processor(processor)
                ]
            )
        } else {
            avatarImageView.kf.cancelDownloadTask()
        }
    }
}
