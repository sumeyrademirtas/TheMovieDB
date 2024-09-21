//
//  DetailViewModel.swift
//  TheMovieDB
//
//  Created by Sümeyra Demirtaş on 10.09.2024.
//

// Bu dosyayi bu sekilde yaptigim icin pismanim. Bolsem daha iyi olabilirdi. Cok ugrastirdi sonrasinda.
import Foundation

struct DetailViewModel {
    
    private let tvserie: TvSeries?
    private let movie: Movie?
    
    // Movie bilgileri
    var movieoriginalLanguage: String? { movie?.originalLanguage }
    var movietitle: String? { movie?.title }
    var movieoriginalTitle: String? { movie?.originalTitle }
    var movieoverview: String? { movie?.overview }
    var movieposterPath: String? { movie?.posterPath }
    var moviereleaseDate: String? { movie?.releaseDate }
    var movievoteAverage: String? { movie != nil ? String(format: "%.1f", movie!.voteAverage) : nil }
    
    // TV Series bilgileri
    var tvoriginalLanguage: String? { tvserie?.originalLanguage }
    var tvoriginalName: String? { tvserie?.originalName }
    var tvoverview: String? { tvserie?.overview }
    var tvposterPath: String? { tvserie?.posterPath }
    var tvfirstAirDate: String? { tvserie?.firstAirDate }
    var tvname: String? { tvserie?.name }
    var tvvoteAverage: String? { tvserie != nil ? String(format: "%.1f", tvserie!.voteAverage) : nil }
    
    // Movie init
    init(movie: Movie) {
        self.movie = movie
        self.tvserie = nil
    }
    
    // TV Series init
    init(tvserie: TvSeries) {
        self.tvserie = tvserie
        self.movie = nil
    }
}
