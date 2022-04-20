//
//  CharacterCell.swift
//  RickAndMortyTestTask
//
//  Created by  Егор Шуляк on 19.04.22.
//

import UIKit
import SnapKit
import Kingfisher

final class CharacterCell: UITableViewCell {
    static let reuseID = String(describing: CharacterCell.self)
    
    private var avatarImageView = UIImageView()
    private var nameLabel = UILabel()
    private var speciesLabel = UILabel()
    private var genderLabel = UILabel()
    
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
    
    private func configureViews() {
        // configure imageView
        contentView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(5)
            make.centerY.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(avatarImageView.snp.height)
        }
        avatarImageView.backgroundColor = .lightGray
        
        // configure nameLabel
        nameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        nameLabel.textColor = .black
        nameLabel.numberOfLines = 0
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(5)
            make.top.equalToSuperview().inset(5)
            make.right.equalToSuperview().inset(5)
        }
        
        // configure speciesLabel
        speciesLabel.font = UIFont.systemFont(ofSize: 13)
        speciesLabel.textColor = .lightGray
        speciesLabel.numberOfLines = 1
        contentView.addSubview(speciesLabel)
        speciesLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(5)
            make.right.equalToSuperview().inset(5)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
        
        // configure genderLabel
        genderLabel.font = UIFont.systemFont(ofSize: 13)
        genderLabel.textColor = .lightGray
        genderLabel.numberOfLines = 1
        contentView.addSubview(genderLabel)
        genderLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(5)
            make.right.equalToSuperview().inset(5)
            make.top.equalTo(speciesLabel.snp.bottom).offset(5)
            make.bottom.equalToSuperview().inset(5)
        }
    }
    
    func configureCell(name: String, species: String, gender: String) {
        nameLabel.text = name
        speciesLabel.text = species
        genderLabel.text = gender
    }
    
    func downloadImageForCell(avatar: String?) {
        if let urlString = avatar, let url = URL(string: urlString) {
//            KingfisherManager.shared.downloader.downloadTimeout = 600
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
