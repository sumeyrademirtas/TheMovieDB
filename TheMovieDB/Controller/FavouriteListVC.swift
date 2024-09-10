//
//  favouriteListVC.swift
//  TheMovieDB
//
//  Created by Sümeyra Demirtaş on 9.09.2024.
//

import Foundation
import UIKit

import UIKit

final class FavouriteListVC: UIViewController {
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favourites"
        setupTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadFavourites), name: NSNotification.Name("favouriteUpdated"), object: nil)
        tableView.reloadData()

    }
    
    @objc private func reloadFavourites() {
        tableView.reloadData() // Favoriler güncellendiğinde tabloyu yenile
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
    }


}

extension FavouriteListVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FavouriteManager.shared.favouriteItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let item = FavouriteManager.shared.favouriteItems[indexPath.row]
        
        switch item {
        case .movie(let movie):
            cell.textLabel?.text = movie.title
            cell.detailTextLabel?.text = "Movie"
        case .tvSeries(let tvSeries):
            cell.textLabel?.text = tvSeries.name
            cell.detailTextLabel?.text = "TV Series"
        }
        
        return cell
    }
}

