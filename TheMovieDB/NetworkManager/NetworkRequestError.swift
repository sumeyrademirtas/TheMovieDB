//
//  NetworkRequestError.swift
//  TheMovieDB
//
//  Created by Sümeyra Demirtaş on 9.09.2024.
//

import Foundation

// NetworkRequestError, ağ isteği sırasında karşılaşılan olası hataları temsil eden bir enum'dur.
// LocalizedError protokolü, hataların açıklamalarını kullanıcı dostu hale getirmek için kullanılır.
// Equatable protokolü, hata türlerinin karşılaştırılabilmesini sağlar.

enum NetworkRequestError: LocalizedError, Equatable {
    case invalidRequest // Geçersiz istek hatası
    case badRequest // HTTP 400: Hatalı istek
    case unauthorized // HTTP 401: Yetkilendirme hatası
    case forbidden // HTTP 403: Erişim izni reddedildi
    case notFound // HTTP 404: Kaynak bulunamadı
    case error4xx(_ code: Int) // 400-499 arası diğer istemci taraflı hatalar
    case serverError // HTTP 500: Sunucu hatası
    case error5xx(_ code: Int) // 500-599 arası sunucu taraflı hatalar
    case decodingError(_ description: String) // JSON decode edilirken oluşan hatalar
    case urlSessionFailed(_ error: URLError) // URLSession ile ilgili bir hata oluştuğunda
    case timeOut // İstek zaman aşımına uğradığında
    case unknownError // Bilinmeyen bir hata meydana geldiğinde
    case customError(_ message: String) // Kullanıcı tarafından özelleştirilmiş hata mesajları
}
