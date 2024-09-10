//
//  TvSeriesListViewModel.swift
//  TheMovieDB
//
//  Created by Sümeyra Demirtaş on 10.09.2024.
//

import Foundation
import Combine

class TvSeriesListViewModel {
    // Combine için bir `Set` kullanarak memory management sağlarız
    private var cancelable = Set<AnyCancellable>()
    
    // Çekilecek dizi verilerini tutacak dizi
    var tvSeries: [TvSeries] = []
    
    var didFetchTvSeries: (() -> Void)?
    
    // TvSeries verilerini fetch etmek için fonksiyon
    func fetchTvSeries() {
            NetworkClient.dispatch(NetworkRouter.fetchTvSeries())
                .sink { [weak self] completion in
                    guard let self = self else { return }
                    switch completion {
                    case .finished:
                        print("TV Series fetched successfully")
                    case .failure(let error):
                        print("Failed to fetch TV series: \(error)")
                    }
                } receiveValue: { [weak self] response in
                    self?.tvSeries = response.results
                    self?.didFetchTvSeries?() // TV series fetched, reload the table
                }
                .store(in: &cancelable)
        }
    
    // TvSeriesViewModel döndürmek için bir fonksiyon
    func tvSeriesViewModel(at index: Int) -> TvSeriesViewModel {
        let tvSeries = tvSeries[index]
        return TvSeriesViewModel(tvSeries: tvSeries)
    }
}
