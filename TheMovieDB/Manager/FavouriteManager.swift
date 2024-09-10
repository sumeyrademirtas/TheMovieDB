//
//  FavouriteManager.swift
//  TheMovieDB
//
//  Created by Sümeyra Demirtaş on 10.09.2024.
//

import Foundation

final class FavouriteManager {
    // Singleton instance; uygulama boyunca tek bir `FavouriteManager` kullanılacak
    static let shared = FavouriteManager()
    
    // Dışarıdan sadece okunabilir, fakat sadece bu sınıf içinde değiştirilebilir bir favori listesi
    private(set) var favouriteItems: [MediaType] = []
    
    // Özel init, böylece sınıfın başka yerlerde yeni bir instance'ı oluşturulamaz
    private init() {}
    
    // Favorilere yeni bir öğe ekleme fonksiyonu
    func addToFavourites(_ item: MediaType) {
        favouriteItems.append(item) // Verilen öğe (film ya da TV dizisi) favori listesine eklenir
    }
    
    // Favorilerden bir öğeyi çıkarma fonksiyonu
    func removeFromFavourites(_ item: MediaType) {
        // Eğer öğe favori listesinde bulunuyorsa, diziden kaldırılır
        if let index = favouriteItems.firstIndex(where: { $0 == item }) {
            favouriteItems.remove(at: index)
        }
    }
    
    // Bir öğenin favori olup olmadığını kontrol eden fonksiyon
    func isFavourite(_ item: MediaType) -> Bool {
        // Eğer öğe favori listesinde bulunuyorsa true, aksi halde false döner
        return favouriteItems.contains(where: { $0 == item })
    }
}
