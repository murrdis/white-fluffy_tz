//
//  PhotoDetailContentView.swift
//  W&F_tz
//
//  Created by Диас Мурзагалиев on 16.02.2024.
//

import UIKit

protocol PhotoDetailContentViewDelegate: AnyObject {
    func didTapBackButton()
    func didTapFavoriteButton()
    func didTapShareButton(sender: UIButton, image: UIImage)
}

class PhotoDetailContentView: UIView {
    weak var delegate: PhotoDetailContentViewDelegate?
    
    lazy var navigationButtonsStackView = makeNavigationButtonsStackView()
    lazy var shareButton = makeShareButton()
    lazy var backButton = makeBackButton()
    lazy var headerStackView = makeHeaderStackView()
    lazy var authorLabel = makeAuthorLabel()
    lazy var photoImageView = makePhotoImageView()
    lazy var dateLabel = makeDateLabel()
    lazy var locationStackView = makeLocationStackView()
    lazy var locationLabel = makeLocationLabel()
    lazy var locationIconImageView = makeLocationIconImageView()
    lazy var favoriteDownloadsStackView = makeFavoriteDownloadsStackView()
    lazy var downloadsStackView = makeDownloadsStackView()
    lazy var downloadsLabel = makeDownloadsLabel()
    lazy var downloadsIconImageView = makeDownloadsIconImageView()
    lazy var favoriteButton = makeFavoriteButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .white
        [
            navigationButtonsStackView,
            headerStackView,
            locationStackView,
            photoImageView,
            favoriteDownloadsStackView
        ].forEach { addSubview($0) }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            navigationButtonsStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0),
            navigationButtonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            navigationButtonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            navigationButtonsStackView.heightAnchor.constraint(equalToConstant: 44),
            
            headerStackView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 40),
            headerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            headerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            locationStackView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 10),
            locationStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            locationStackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20),
            
            photoImageView.topAnchor.constraint(equalTo: locationStackView.bottomAnchor, constant: 20),
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            photoImageView.heightAnchor.constraint(equalTo: widthAnchor),
            
            favoriteDownloadsStackView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 10),
            favoriteDownloadsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            favoriteDownloadsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            favoriteDownloadsStackView.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    

    private func makeNavigationButtonsStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [backButton, shareButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func makeShareButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    @objc func shareButtonTapped(_ sender: UIButton) {
        delegate?.didTapShareButton(sender: sender, image: photoImageView.image!)
        
    }
    
    private func makeBackButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }
    
    @objc func backButtonTapped() {
        delegate?.didTapBackButton()
    }
    
    private func makeHeaderStackView() -> UIStackView {
        let spacerView = UIView()
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacerView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        let stackView = UIStackView(
            arrangedSubviews:
                [
                    authorLabel,
                    spacerView,
                    dateLabel
                ]
        )
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func makeDateLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func makeLocationStackView() -> UIStackView {
        let stackView = UIStackView(
            arrangedSubviews:
                [
                    locationIconImageView,
                    locationLabel
                ]
        )
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func makeLocationLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func makeLocationIconImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "mappin.and.ellipse")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    private func makeDownloadsStackView() -> UIStackView {
        let stackView = UIStackView(
            arrangedSubviews:
                [
                    downloadsLabel,
                    downloadsIconImageView
                ]
        )
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    
    private func makeDownloadsLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func makeFavoriteDownloadsStackView() -> UIStackView {
        let spacerView = UIView()
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacerView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        favoriteButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        downloadsStackView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let stackView = UIStackView(
            arrangedSubviews: [
                favoriteButton,
                spacerView,
                downloadsStackView
            ]
        )
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    
    private func makeDownloadsIconImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "square.and.arrow.down")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    private func makeFavoriteButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate) {
            button.setImage(image, for: .normal)
            button.tintColor = .black
        }
        
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        
        button.imageView?.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFit
        
        if let imageView = button.imageView {
            NSLayoutConstraint.activate([
                imageView.heightAnchor.constraint(equalToConstant: 40),
                imageView.widthAnchor.constraint(equalToConstant: 40),
                imageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
                imageView.centerXAnchor.constraint(equalTo: button.centerXAnchor)
            ])
        }
        
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }
    
    @objc func favoriteButtonTapped() {
        delegate?.didTapFavoriteButton()
    }
}
