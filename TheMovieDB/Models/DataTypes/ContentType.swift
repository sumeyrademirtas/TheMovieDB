//
//  ContentType.swift
//  TheMovieDB
//
//  Created by Sümeyra Demirtaş on 10.09.2024.
//

import Foundation

enum MediaType: Equatable {
    case movie(Movie)
    case tvSeries(TvSeries)
}
