//
//  FavouriteTvSeriesResponseModel.swift
//  TheMovieDB
//
//  Created by Sümeyra Demirtaş on 12.09.2024.
//

struct FavoriteTvSeriesResponseModel: Codable {
    let page: Int
    let results: [TvSeries]
    let total_pages: Int
    let total_results: Int
}
