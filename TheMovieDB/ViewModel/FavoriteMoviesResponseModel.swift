//
//  FavouriteMoviesResponseModel.swift
//  TheMovieDB
//
//  Created by Sümeyra Demirtaş on 12.09.2024.
//

struct FavoriteMoviesResponseModel: Codable {
    let page: Int
    let results: [Movie]
    let total_pages: Int
    let total_results: Int
}
