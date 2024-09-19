//
//  AddFavoriteResponseModel.swift
//  TheMovieDB
//
//  Created by Sümeyra Demirtaş on 14.09.2024.
//

import Foundation

struct AddFavoriteResponseModel: Codable {
    let statusCode: Int
    let statusMessage: String
    let success: Bool

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case success
    }
}
