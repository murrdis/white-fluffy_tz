//
//  TabBarController.swift
//  W&F_tz
//
//  Created by Диас Мурзагалиев on 14.02.2024.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        viewControllers = [
            generateNavVC(rootVC: PhotosViewController(collectionViewLayout: UICollectionViewFlowLayout()), title: "Photos", image: UIImage(systemName: "photo")!),
            generateNavVC(rootVC: FavoritesViewController(style: .plain), title: "Favorites", image: UIImage(systemName: "heart")!)
        ]
        self.delegate = self
    }
    
    private func generateNavVC(rootVC: UIViewController, title: String, image: UIImage) -> UINavigationController {
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.tabBarItem.title = title
        navVC.tabBarItem.image = image
        return navVC
    }
}

extension TabBarController {

    // MARK:  Animation
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
            return false
        }

        if fromView == toView {
            return true
        }
        
        UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        
        return true
    }
}
