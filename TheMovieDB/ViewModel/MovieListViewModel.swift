//
//  MovieListViewModel.swift
//  TheMovieDB
//
//  Created by Sümeyra Demirtaş on 9.09.2024.
//

import Foundation
import Combine

class MovieListViewModel {
    // Combine için bir `Set` kullanarak memory management sağlarız
    private var cancelable = Set<AnyCancellable>()
    
    // Çekilecek filmleri tutacak dizi
    var movies: [Movie] = []
    
    var didFetchMovies: (() -> Void)?
    
    // Movie verilerini fetch etmek için fonksiyon
    func fetchMovies() {
            NetworkClient.dispatch(NetworkRouter.fetchMovies())
                .sink { [weak self] completion in
                    guard let self = self else { return }
                    switch completion {
                    case .finished:
                        print("Movies fetched successfully")
                    case .failure(let error):
                        print("Failed to fetch movies: \(error)")
                    }
                } receiveValue: { [weak self] response in
                    self?.movies =  response.results
                    self?.didFetchMovies?() // Movies fetched, reload the table
                }
                .store(in: &cancelable)
        }
    
    // MovieViewModel döndürmek için bir fonksiyon
        func movieViewModel(at index: Int) -> MovieViewModel {
            let movie = movies[index]
            return MovieViewModel(movie: movie)
        }
}
