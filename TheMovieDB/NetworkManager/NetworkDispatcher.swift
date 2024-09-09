//
//  NetworkDispatcher.swift
//  TheMovieDB
//
//  Created by Sümeyra Demirtaş on 9.09.2024.
//

import Combine
import Foundation
import os

// NetworkDispatcher struct'ı, ağ isteklerini yöneten yapı
struct NetworkDispatcher {
    let urlSession: URLSession // URLSession oturumu, varsayılan olarak shared oturumu kullanıyor
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "network") // Loglama için Logger nesnesi

    // Yapıcı fonksiyon, URLSession oturumunu alır ve varsayılan olarak shared oturumunu kullanır
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    /// URLRequest'i işleyip bir publisher döndürür
    /// - Parameter request: URLRequest tipi, gönderilecek olan ağ isteği
    /// - Returns: Decode edilmiş veri veya hata döndüren bir publisher
    func dispatch<ReturnType: Codable>(request: URLRequest) -> AnyPublisher<ReturnType, NetworkRequestError> {
        logger.info("[\(request.httpMethod?.uppercased() ?? "")] '\(request.url!)'") // İstek bilgilerini logluyor
        return urlSession
            .dataTaskPublisher(for: request) // URLRequest'e ait data task publisher oluşturuyor
            .subscribe(on: DispatchQueue.global(qos: .default)) // İşlem arka planda, global kuyruğunda gerçekleşiyor
            .tryMap { data, response in // Gelen veri ve cevabı işlemeye başlıyor
                guard let response = response as? HTTPURLResponse else {
                    throw httpError(0) // Eğer cevap HTTPURLResponse değilse hata fırlatılıyor
                }

                logger.log("[\(response.statusCode)] '\(request.url!)'") // HTTP yanıt kodunu logluyor

                if !(200...299).contains(response.statusCode) { // Yanıt kodu 200 ile 299 arasında değilse hata fırlatılıyor
                    throw httpError(response.statusCode)
                }
                return data // Eğer hata yoksa veriyi döndürüyor
            }
            .receive(on: DispatchQueue.main) // Ana iş parçacığında sonuç döndürülüyor (UI güncellemeleri için)
            .decode(type: ReturnType.self, decoder: JSONDecoder()) // Gelen veriyi decode edip model tipine dönüştürüyor
            .mapError { error in // Hataları map ediyor ve uygun hatayı logluyor
                logger.error("\(error)'")
                return handleError(error) // Hatalar handleError fonksiyonu ile işleniyor
            }
            .eraseToAnyPublisher() // Publisher tipini AnyPublisher'a dönüştürüp döndürüyor
    }

    /// HTTP Status kodunu alıp uygun hata döndüren fonksiyon
    /// - Parameter statusCode: HTTP status kodu
    /// - Returns: Mapped Error
    private func httpError(_ statusCode: Int) -> NetworkRequestError {
        switch statusCode {
        case 400: return .badRequest // 400: Hatalı istek
        case 401: return .unauthorized // 401: Yetkilendirme hatası
        case 403: return .forbidden // 403: Erişim izni yok
        case 404: return .notFound // 404: Bulunamadı
        case 402, 405...499: return .error4xx(statusCode) // 4xx aralığındaki diğer hatalar
        case 500: return .serverError // 500: Sunucu hatası
        case 501...599: return .error5xx(statusCode) // 5xx aralığındaki sunucu hataları
        default: return .unknownError // Diğer tüm durumlar için bilinmeyen hata
        }
    }

    /// URLSession Publisher hatalarını işleyip uygun hataları döndüren fonksiyon
    /// - Parameter error: URLSession'dan dönen hata
    /// - Returns: Okunabilir NetworkRequestError hatası
    private func handleError(_ error: Error) -> NetworkRequestError {
        switch error {
        case is Swift.DecodingError:
            return .decodingError(error.localizedDescription) // Decoding hatası varsa bu döndürülüyor
        case let urlError as URLError:
            return .urlSessionFailed(urlError) // URLSession ile ilgili hata varsa
        case let error as NetworkRequestError:
            return error // Eğer zaten bir NetworkRequestError ise bu hata döndürülüyor
        default:
            return .unknownError // Diğer durumlarda bilinmeyen hata döndürülüyor
        }
    }
}
