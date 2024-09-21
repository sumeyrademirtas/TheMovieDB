//
//  NetworkRouter.swift
//  TheMovieDB
//
//  Created by Sümeyra Demirtaş on 9.09.2024.
//

import Foundation

class NetworkRouter {
    // MARK: - Fetch Popular Movies

    struct fetchMovies: NetworkRequest {
        typealias ReturnType = MovieResponseModel
        var path: String = "/movie/popular"
        var method: HttpMethod = .get
        var body: [String: Any]?
    }

    // MARK: - Fetch Popular TV Series

    struct fetchTvSeries: NetworkRequest {
        typealias ReturnType = TvSeriesResponseModel
        var path: String = "/tv/popular"
        var method: HttpMethod = .get
        var body: [String: Any]?
    }

    // MARK: - Add Favorite Reqeust

    struct AddFavoriteRequest: NetworkRequest {
        typealias ReturnType = AddFavoriteResponseModel

        var mediaType: String // "movie" veya "tv"
        var mediaId: Int // Favoriye eklemek istediğiniz medya ID'si
        var favorite: Bool // Favoriye eklemek veya çıkarmak için (true veya false)

        var path: String {
            return "/account/\(ENV.ACCOUNT_ID)/favorite" // `ENV` kullanılarak ACCOUNT_ID alınıyor
        }

        var method: HttpMethod = .post // POST isteği ile favori eklenir veya çıkarılır

        var body: [String: Any]?

        // Initialize method for setting the body
        // body icin init hazirlamayinca hata verdi.
        // body property’si şu an sadece bir get metodu içeriyor ve set edilemiyor.
        // Eğer body’yi set etmeniz gerekiyorsa, protokolde bunu bir var olarak tanımlayıp, get ve set metodlarını kullanabilirsiniz.
        init(mediaType: String, mediaId: Int, favorite: Bool) {
            self.mediaType = mediaType
            self.mediaId = mediaId
            self.favorite = favorite
            self.body = [
                "media_type": mediaType,
                "media_id": mediaId,
                "favorite": favorite
            ]
        }

    }

    // MARK: - Fetch Favorite Movie Request

    struct FavoriteMovieRequest: NetworkRequest {
        typealias ReturnType = FavoriteMoviesResponseModel
        let mediaId: Int

        var path: String {
            return "/account/\(ENV.ACCOUNT_ID)/favorite/movies"
        }

        var method: HttpMethod = .get
        var body: [String: Any]? = nil
        var queryParams: [String: Any]? = nil

        // Eklenen favori filmleri çekmek için yapılandırılmış bir istek
    }

    // MARK: - Fetch Favorite Tv Series Request

    struct FavoriteTvSeriesRequest: NetworkRequest {
        typealias ReturnType = FavoriteTvSeriesResponseModel
        let mediaId: Int

        var path: String {
            return "/account/\(ENV.ACCOUNT_ID)/favorite/tv"
        }

        var method: HttpMethod = .get
        var body: [String: Any]? = nil
        var queryParams: [String: Any]? = nil

        // Eklenen favori TV dizilerini çekmek için yapılandırılmış bir istek
    }
}


