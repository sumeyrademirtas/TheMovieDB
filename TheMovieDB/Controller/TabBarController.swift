//
//  TabBarController.swift
//  TheMovieDB
//
//  Created by Sümeyra Demirtaş on 9.09.2024.
//

import UIKit

/// Controller to house tabs and root tab controllers
final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpTabs()
    }

    private func setUpTabs() {
        let movieTvListVC = MovieTvListVC()
        let favouriteListVC = FavouriteListVC()

        let nav1 = UINavigationController(rootViewController: movieTvListVC)
        let nav2 = UINavigationController(rootViewController: favouriteListVC)

        nav1.tabBarItem = UITabBarItem(title: "Movie/TV Series List", image: UIImage(systemName: "movieclapper"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Favourite Lists", image: UIImage(systemName: "star.fill"), tag: 2)

        setViewControllers([nav1, nav2], animated: true)
    }
}
