//
//  MovieViewModel.swift
//  TheMovieDB
//
//  Created by Sümeyra Demirtaş on 9.09.2024.
//

import Foundation

struct MovieViewModel: Codable {
    let id: Int
    let originalLanguage: String
    let title: String
    let originalTitle: String
    let overview: String
    let posterPath: String?
    let releaseDate: String
    let voteAverage: Double

    // Movie modelini kullanarak MovieViewModel oluştururuz
    init(movie: Movie) {
        self.id = movie.id
        self.originalLanguage = movie.originalLanguage
        self.title = movie.title
        self.originalTitle = movie.originalTitle
        self.overview = movie.overview
        self.posterPath = movie.posterPath
        self.releaseDate = movie.releaseDate
        self.voteAverage = movie.voteAverage
    }
}
