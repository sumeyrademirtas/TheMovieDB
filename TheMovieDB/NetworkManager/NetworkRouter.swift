//
//  NetworkRouter.swift
//  TheMovieDB
//
//  Created by Sümeyra Demirtaş on 9.09.2024.
//

import Foundation

class NetworkRouter {
    struct fetchMovies: NetworkRequest {
        
        typealias ReturnType = [MovieResponseModel]
        var path: String = "movie/popular"
        var method: HttpMethod = .get
        var body: [String : Any]?
        
    }
    
    // you can add a new struct for each request now
//    struct createPost: NetworkRequest {
//        typealias ReturnType = ResponseModel
//        var path: String = "/posts"
//        var method: HttpMethod = .post
//        var body: [String : Any]?
//        
//        init(body: RequestModel) {
//            self.body = body.asDictionary
//        }
//    }
    
}
