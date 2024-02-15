//
//  FavoritesTableViewCell.swift
//  W&F_tz
//
//  Created by Диас Мурзагалиев on 14.02.2024.
//

import UIKit
import SDWebImage

class FavoriteTableViewCell: UITableViewCell {
    private lazy var photoImageView = makePhotoImageView()
    private lazy var authorLabel = makeAuthorLabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }


    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with favoritePhoto: DetailPhoto) {
        setup()
        
        if let imageUrl = URL(string: favoritePhoto.urls["regular"]!) {
            photoImageView.sd_setImage(with: imageUrl)
        }
        authorLabel.text = favoritePhoto.user.name
    }

    private func setup() {
        [
            photoImageView,
            authorLabel
        ].forEach { addSubview($0) }

        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            photoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 10),
            authorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            authorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            authorLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10)
        ])
    }

    
    private func makePhotoImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    private func makeAuthorLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

