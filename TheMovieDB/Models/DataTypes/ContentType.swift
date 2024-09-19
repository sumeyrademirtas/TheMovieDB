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
    
    // Computed property to extract ID
     var id: Int {
         switch self {
         case .movie(let movie):
             return movie.id
         case .tvSeries(let tvSeries):
             return tvSeries.id
         }
     }
}
