//
//  PhotoDetailViewController.swift
//  W&F_tz
//
//  Created by Диас Мурзагалиев on 14.02.2024.
//

import UIKit
import SDWebImage

class PhotoDetailViewController: UIViewController {
    private var contentView = PhotoDetailContentView()

    private let customDateFormatter = CustomDateFormatter()
    private let networkService = NetworkService()
    private let memoryService = MemoryService()
    
    var photo: DetailPhoto
    var detailPhoto: DetailPhoto?
    
    init(photo: DetailPhoto) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        getDetailPhoto()
        setup()
    }
    
    private func getDetailPhoto() {
        networkService.getPhoto(withID: photo.id) { [weak self] photo in
            if let photo = photo {
                DispatchQueue.main.async {
                    self?.detailPhoto = photo
                    print(photo)
                    self?.updateUI()
                }
            }
        }
    }
    
    private func updateUI() {
        var locationText = "unknown"
        
        if let city = detailPhoto?.location?.city, let country = detailPhoto?.location?.country {
            locationText = "\(city), \(country)"
        } else if let city = detailPhoto?.location?.city {
            locationText = city
        } else if let country = detailPhoto?.location?.country {
            locationText = country
        }
        
        contentView.locationLabel.text = locationText
        
        if let downloads = detailPhoto?.downloads {
            contentView.downloadsLabel.text = "\(downloads)"
        } else {
            contentView.downloadsLabel.text = "0"
        }
    }
    
    private func setup() {
        contentView.delegate = self
        [
            contentView
        ].forEach { view.addSubview($0) }
        
        setupConstraints()
        setupUI()
    }
    
    private func setupUI() {
        let photoURL = photo.urls["regular"]
        guard let imageURL = photoURL, let url = URL(string: imageURL) else { return }
        contentView.photoImageView.sd_setImage(with: url)
        contentView.authorLabel.text = photo.user.name
        if let date = customDateFormatter.convertDateString(photo.created_at) {
            contentView.dateLabel.text = date
        }
        let favorites = memoryService.getFavorites()
        if favorites.contains(where: { $0 == photo.id }) {
            contentView.favoriteButton.tintColor = .red
            contentView.favoriteButton.isSelected = true
        }
    }
    
    private func setupConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
}


extension PhotoDetailViewController: PhotoDetailContentViewDelegate {
    func didTapFavoriteButton() {
        if contentView.favoriteButton.isSelected {
            let alert = UIAlertController(title: "Remove from Favorites", message: "Are you sure you want to remove this image from your favorites?", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { [weak self] _ in
                self?.memoryService.removeFromFavorites(photoID: self?.photo.id ?? "")
                self?.contentView.favoriteButton.tintColor = .black
                self?.contentView.favoriteButton.isSelected = false
                self?.didTapBackButton()
            }))

            present(alert, animated: true, completion: nil)
        } else {
            memoryService.addToFavorites(photoID: photo.id)
            contentView.favoriteButton.tintColor = .red
            contentView.favoriteButton.isSelected = true
        }
    }
    
    
    func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    func didTapShareButton(sender: UIButton, image: UIImage) {
        let shareController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        shareController.completionWithItemsHandler = {  _, bool, _, _ in
            if bool {
            }
        }

        if let popoverController = shareController.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
            popoverController.permittedArrowDirections = .any
        }
        
        present(shareController, animated: true, completion: nil)
    }
}
