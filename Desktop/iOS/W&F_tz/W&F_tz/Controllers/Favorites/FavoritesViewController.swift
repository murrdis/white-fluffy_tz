//
//  FavoritesViewController.swift
//  W&F_tz
//
//  Created by Диас Мурзагалиев on 14.02.2024.
//

import UIKit

class FavoritesViewController: UITableViewController {
    private let networkService = NetworkService()
    private let memoryService = MemoryService()
    private var customTransitionDelegate = CustomTransitionDelegate()
    
    var favorites: [DetailPhoto] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPhotosFromUnsplash()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        tableView.showsVerticalScrollIndicator = false
        tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: "FavoriteCell")
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Favorites"
    }
    
    private func getPhotosFromUnsplash() {
        var loadedFavorites: [DetailPhoto] = []
        let favoriteIds = memoryService.getFavorites()

        let dispatchGroup = DispatchGroup()

        for id in favoriteIds {
            dispatchGroup.enter()
            networkService.getPhoto(withID: id) { photo in
                if let photo = photo {
                    loadedFavorites.append(photo)
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.favorites = loadedFavorites
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteTableViewCell
        let favoritePhoto = favorites[indexPath.row]
        cell.configure(with: favoritePhoto)
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailPhoto = favorites[indexPath.row]
        let photoDetailViewController = PhotoDetailViewController(photo: detailPhoto)
        
        photoDetailViewController.transitioningDelegate = customTransitionDelegate
        photoDetailViewController.modalPresentationStyle = .fullScreen
        present(photoDetailViewController, animated: true)
    }


}



