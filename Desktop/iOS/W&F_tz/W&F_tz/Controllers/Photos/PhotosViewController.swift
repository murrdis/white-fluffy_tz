//
//  PhotosViewController.swift
//  W&F_tz
//
//  Created by Диас Мурзагалиев on 14.02.2024.
//

import UIKit

class PhotosViewController: UICollectionViewController {
    private let refreshControl = UIRefreshControl()
    private lazy var selectButton: UIButton = makeSelectButton()
    private lazy var shareButton: UIButton = makeShareButton()
    private lazy var favoriteButton: UIButton = makeFavoriteButton()
    
    
    private let networkService = NetworkService()
    private let memoryService = MemoryService()
    private var timer: Timer?
    private var customTransitionDelegate = CustomTransitionDelegate()
    private var isSelectionModeEnabled = false
    private var selectedImages = [UIImage]()
    private var selectedIDs = [String]()
    
    private var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        collectionView.backgroundColor = .white
        [
            selectButton,
            shareButton,
            favoriteButton
        ].forEach { view.addSubview($0) }
        setupNavigationBar()
        setupCollectionView()
        setupConstraints()
        setupRefreshControl()
        
        getRandomPhotos()
    }
    
    private func getRandomPhotos(completion: (() -> Void)? = nil) {
        networkService.getRandomPhotos { [weak self] randomPhotos in
            guard let photos = randomPhotos else {
                completion?()
                return
            }
            self?.photos = photos
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.updateSelectButtonVisibility()
                completion?()
            }
        }
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Photos"
        setupSearchBar()
        
        definesPresentationContext = true
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search Unsplash Photos"
        navigationItem.searchController = searchController
    }
    
    private func setupCollectionView() {
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: (view.frame.width / 3) - 1, height: (view.frame.width / 3) - 1)
            layout.minimumInteritemSpacing = 1
            layout.minimumLineSpacing = 1
        }
    }
    
    private func setupRefreshControl() {
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(refreshPhotos(_:)), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc private func refreshPhotos(_ sender: UIRefreshControl) {
        getRandomPhotos(completion: {
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        })
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            selectButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            selectButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            selectButton.widthAnchor.constraint(equalToConstant: 70),
            selectButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        NSLayoutConstraint.activate([
            shareButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            shareButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
        ])
        NSLayoutConstraint.activate([
            favoriteButton.leadingAnchor.constraint(equalTo: shareButton.trailingAnchor, constant: 10),
            favoriteButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
        ])
    }
    
    private func makeSelectButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle("Select", for: .normal)
        button.setTitle("Cancel", for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.layer.cornerRadius = 15
        button.backgroundColor = UIColor.darkGray.withAlphaComponent(0.85)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(selectButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    @objc func selectButtonTapped(_ sender: UIBarButtonItem) {
        sender.isSelected.toggle()
        isSelectionModeEnabled.toggle()
        collectionView.allowsMultipleSelection = isSelectionModeEnabled
        
        if !isSelectionModeEnabled {
            shareButton.isHidden = true
            favoriteButton.isHidden = true
            
            for indexPath in collectionView.indexPathsForSelectedItems ?? [] {
                collectionView.deselectItem(at: indexPath, animated: false)
            }
        }
    }
    
    private func makeShareButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 15
        button.backgroundColor = UIColor.darkGray.withAlphaComponent(0.85)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(shareButtonTapped(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 40),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
        button.layer.cornerRadius = 20
        
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        return button
    }
    
    @objc func shareButtonTapped(_ sender: UIBarButtonItem) {
        let shareController = UIActivityViewController(activityItems: selectedImages, applicationActivities: nil)
        
        shareController.completionWithItemsHandler = {_, bool, _, _ in
            if bool {
                self.refresh()
            }
        }
        
        shareController.popoverPresentationController?.barButtonItem = sender
        shareController.popoverPresentationController?.permittedArrowDirections = .any
        present(shareController, animated: true, completion: nil)
    }
    
    func refresh() {
        selectedImages.removeAll()
        selectedIDs.removeAll()
        isSelectionModeEnabled = false
        selectButton.isSelected = false
        shareButton.isHidden = true
        favoriteButton.isHidden = true
        collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
        
    }
    
    private func makeFavoriteButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.backgroundColor = UIColor.darkGray.withAlphaComponent(0.85)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(favoriteButtonTapped(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 40),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        
        return button
    }
    
    @objc func favoriteButtonTapped(_ sender: UIBarButtonItem) {
        selectedIDs.forEach { photoID in
            memoryService.addToFavorites(photoID: photoID)
        }
        self.refresh()
    }
    
    // MARK: - UIScrollViewDelegate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let navigationBarHeight = navigationController?.navigationBar.frame.height ?? 0
        let isLargeTitleVisible = scrollView.contentOffset.y < ((navigationBarHeight - scrollView.safeAreaInsets.top) - 50)
        
        selectButton.isHidden = isLargeTitleVisible
        if isSelectionModeEnabled {
            shareButton.isHidden = isLargeTitleVisible
            favoriteButton.isHidden = isLargeTitleVisible
        }
    }
}

// MARK: - UICollectionViewDelegate Methods

extension PhotosViewController: PhotoCollectionViewCellDelegate {
    func shouldUpdateUIForSelection(in cell: PhotoCollectionViewCell) -> Bool {
        return isSelectionModeEnabled
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionViewCell
        cell.delegate = self
        cell.configure(photo: photos[indexPath.row])
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isSelectionModeEnabled {
            let detailPhoto = DetailPhoto(
                id: photos[indexPath.row].id,
                created_at: photos[indexPath.row].created_at,
                width: photos[indexPath.row].width,
                height: photos[indexPath.row].height,
                downloads: nil,
                location: nil,
                urls: photos[indexPath.row].urls,
                user: photos[indexPath.row].user)
            
            let photoDetailViewController = PhotoDetailViewController(photo: detailPhoto)
            
            photoDetailViewController.modalPresentationStyle = .fullScreen
            photoDetailViewController.transitioningDelegate = customTransitionDelegate
            present(photoDetailViewController, animated: true)
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as! PhotoCollectionViewCell
            guard let image = cell.photoImageView.image, let photoID = cell.photo?.id else { return }
            selectedImages.append(image)
            selectedIDs.append(photoID)
            shareButton.isHidden = false
            favoriteButton.isHidden = false
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCollectionViewCell
        guard let image = cell.photoImageView.image else { return }
        if let index = selectedImages.firstIndex(of: image) {
            selectedImages.remove(at: index)
            selectedIDs.remove(at: index)
        }
        if selectedImages.count == 0  {
            shareButton.isHidden = true
            favoriteButton.isHidden = true
        }
    }
}

// MARK:  UISearchBarDelegate

extension PhotosViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
            self?.networkService.getPhotos(searchText: searchText) { [weak self] searchResults in
                guard let results = searchResults else { return }
                self?.photos = results.results
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                    self?.updateSelectButtonVisibility()
                }
            }
        })
    }
    
    private func updateSelectButtonVisibility() {
        selectButton.isHidden = photos.isEmpty
    }
}
