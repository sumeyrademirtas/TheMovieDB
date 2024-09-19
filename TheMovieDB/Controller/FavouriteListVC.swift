//
//  favouriteListVC.swift
//  TheMovieDB
//
//  Created by Sümeyra Demirtaş on 9.09.2024.
//

import Foundation
import UIKit
import Combine


final class FavouriteListVC: UIViewController {
    private let tableView = UITableView()
    private var favouriteMovies: [Movie] = []
    private var favouriteTvSeries: [TvSeries] = []
    private var cancellables = Set<AnyCancellable>()


    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favourites"
        setupTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadFavourites), name: NSNotification.Name("favouriteUpdated"), object: nil)
        fetchFavourites()

    }
    
    @objc private func reloadFavourites() {
        // Favori filmleri ve TV dizilerini sıfırla
        // yeni verileri yüklemeden önce eski verileri temizlemek için kullanılır. Eğer bu sıfırlamaları yapmazsanız, her yeni veri çekiminde eski veriler tabloya eklenmeye devam eder ve önceki verilerle karışır.
        favouriteMovies.removeAll()
        favouriteTvSeries.removeAll()
        // Yeniden API'den verileri çek
          fetchFavourites()    }
    
    // Favori filmleri ve TV dizilerini API'den çekme işlemi
       private func fetchFavourites() {
           let group = DispatchGroup() // Film ve dizi verilerini paralel olarak çekmek için

           // Favori Filmleri Çek
           group.enter()
           let movieRequest = NetworkRouter.FavoriteMovieRequest(mediaId: 0) // ID 0 çünkü tüm filmleri çekmek istiyoruz
           NetworkClient.dispatch(movieRequest)
               .sink { completion in
                   switch completion {
                   case .finished:
                       print("Fetched favourite movies successfully")
                   case .failure(let error):
                       print("Failed to fetch favourite movies: \(error)")
                   }
                   group.leave()
               } receiveValue: { [weak self] response in
                   self?.favouriteMovies = response.results
               }
               .store(in: &cancellables)

           // Favori TV Dizilerini Çek
           group.enter()
           let tvRequest = NetworkRouter.FavoriteTvSeriesRequest(mediaId: 0) // ID 0 çünkü tüm TV dizilerini çekmek istiyoruz
           NetworkClient.dispatch(tvRequest)
               .sink { completion in
                   switch completion {
                   case .finished:
                       print("Fetched favourite TV series successfully")
                   case .failure(let error):
                       print("Failed to fetch favourite TV series: \(error)")
                   }
                   group.leave()
               } receiveValue: { [weak self] response in
                   self?.favouriteTvSeries = response.results
               }
               .store(in: &cancellables)

           // Tüm veriler çekildikten sonra tabloyu güncelle
           group.notify(queue: .main) {
               self.tableView.reloadData()
           }
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
        return favouriteMovies.count + favouriteTvSeries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        if indexPath.row < favouriteMovies.count {
                   let movie = favouriteMovies[indexPath.row]
                   cell.textLabel?.text = movie.title
                   cell.detailTextLabel?.text = "Movie"
               } else {
                   let tvIndex = indexPath.row - favouriteMovies.count
                   let tvSeries = favouriteTvSeries[tvIndex]
                   cell.textLabel?.text = tvSeries.name
                   cell.detailTextLabel?.text = "TV Series"
               }
        
        return cell
    }
    
    // Tıklanan öğeye göre DetailsVC'ye yönlendirme
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailsVC = DetailsVC()
        
        if indexPath.row < favouriteMovies.count {
            let movie = favouriteMovies[indexPath.row]
            detailsVC.configure(with: .movie(movie)) // Movie ile configure
        } else {
            let tvIndex = indexPath.row - favouriteMovies.count
            let tvSeries = favouriteTvSeries[tvIndex]
            detailsVC.configure(with: .tvSeries(tvSeries)) // TV Series ile configure
        }
        
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

