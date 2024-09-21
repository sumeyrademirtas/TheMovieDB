//
//  FavouriteManager.swift
//  TheMovieDB
//
//  Created by Sümeyra Demirtaş on 10.09.2024.
//

import Combine
import Foundation

final class FavouriteManager {
    // Singleton instance; uygulama boyunca tek bir `FavouriteManager` kullanılacak
    static let shared = FavouriteManager()
    
    // Combine işlemlerini yönetmek için kullanılan AnyCancellable array'i
    private var cancellables = Set<AnyCancellable>()
    
//    private(set) var favouriteItems: [MediaType] = []
    
    // Özel init, böylece sınıfın başka yerlerde yeni bir instance'ı oluşturulamaz
    private init() {}
    
    // MARK: - API ile Favori İşlemleri
    
    // Favori ekleme fonksiyonu
    func addToFavourites(mediaType: String, mediaId: Int, completion: @escaping (Bool) -> Void) {
        let request = NetworkRouter.AddFavoriteRequest(mediaType: mediaType, mediaId: mediaId, favorite: true)
        // API isteği Combine ile yapılıyor
        NetworkClient.dispatch(request)
            .sink { completionResult in
                switch completionResult {
                case .finished:
                    print("Favorite added successfully.")
                case .failure(let error):
                    print("Failed to add favorite: \(error)")
                    completion(false)
                }
            } receiveValue: { response in
                if response.success {
                    print("Successfully added to favorites: \(response.statusMessage)")
                    completion(true)
                } else {
                    print("Failed to add to favorites: \(response.statusMessage)")
                    completion(false)
                }
            }
            .store(in: &cancellables) // Combine işlemi tamamlandığında veya iptal edilmesi gerektiğinde tutulacak
    }
    
    // Favoriden çıkarma fonksiyonu
    func removeFromFavourites(mediaType: String, mediaId: Int, completion: @escaping (Bool) -> Void) {
        let request = NetworkRouter.AddFavoriteRequest(mediaType: mediaType, mediaId: mediaId, favorite: false) //AddFavoriteRequest i kullanirken favorite yi false yapinca ayni function i remove icin kullanmis olduk.
        NetworkClient.dispatch(request)
            .sink { completionResult in
                switch completionResult {
                case .finished:
                    print("Favorite removed successfully.")
                case .failure(let error):
                    print("Failed to remove favorite: \(error)")
                    completion(false)
                }
            } receiveValue: { response in
                if response.success {
                    print("Successfully removed from favorites: \(response.statusMessage)")
                    completion(true)
                } else {
                    print("Failed to remove from favorites: \(response.statusMessage)")
                    completion(false)
                }
            }
            .store(in: &cancellables)
    }
    
    func isFavourite(_ item: MediaType, completion: @escaping (Bool) -> Void) {
        // Media türüne göre doğru favori API'sini çağır
        switch item {
        case .movie(let movie):
            let request = NetworkRouter.FavoriteMovieRequest(mediaId: movie.id)
            NetworkClient.dispatch(request)
                .sink { completionStatus in
                    switch completionStatus {
                    case .finished:
                        print("Favorite check for movie completed.")
                    case .failure(let error):
                        print("Failed to check favorite status for movie: \(error)")
                        completion(false)
                    }
                } receiveValue: { response in
                    let isFavorite = response.results.contains { $0.id == movie.id }
                    completion(isFavorite)
                }
                .store(in: &cancellables)
            
        case .tvSeries(let tvSeries):
            let request = NetworkRouter.FavoriteTvSeriesRequest(mediaId: tvSeries.id)
            NetworkClient.dispatch(request)
                .sink { completionStatus in
                    switch completionStatus {
                    case .finished:
                        print("Favorite check for TV series completed.")
                    case .failure(let error):
                        print("Failed to check favorite status for TV series: \(error)")
                        completion(false)
                    }
                } receiveValue: { response in
                    let isFavorite = response.results.contains { $0.id == tvSeries.id }
                    completion(isFavorite)
                }
                .store(in: &cancellables)
        }
    }
}
    
