//
//  TvSeriesViewModel.swift
//  TheMovieDB
//
//  Created by Sümeyra Demirtaş on 10.09.2024.
//

import Foundation

struct TvSeriesViewModel: Codable {
    let adult: Bool
    let id: Int
    let originalLanguage: String
    let originalName: String
    let overview: String
    let posterPath: String?
    let firstAirDate: String
    let name: String
    let voteAverage: Double

    // TvSeries modelini kullanarak TvSeriesViewModel oluştururuz
    init(tvSeries: TvSeries) {
        self.adult = tvSeries.adult
        self.id = tvSeries.id
        self.originalLanguage = tvSeries.originalLanguage
        self.originalName = tvSeries.originalName
        self.overview = tvSeries.overview
        self.posterPath = tvSeries.posterPath
        self.firstAirDate = tvSeries.firstAirDate
        self.name = tvSeries.name
        self.voteAverage = tvSeries.voteAverage
    }
}
