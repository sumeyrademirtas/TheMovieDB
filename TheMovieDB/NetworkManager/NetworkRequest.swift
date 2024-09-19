//
//  NetworkRequest.swift
//  TheMovieDB
//
//  Created by Sümeyra Demirtaş on 9.09.2024.
//

import Foundation

// NetworkRequest protokolü, bir ağ isteği oluşturmak için gereken temel özellikleri belirler.
protocol NetworkRequest {
    var path: String { get } // İstek yapılacak URL'nin yolu (örn: /users)
    var method: HttpMethod { get } // HTTP yöntemi (GET, POST, vb.)
    var contentType: String { get } // İçerik türü (örn: application/json)
    var body: [String: Any]? { get set } // Gönderilecek isteğin gövdesi (örn: JSON veri)
    var queryParams: [String: Any]? { get } // Sorgu parametreleri (örn: ?userId=1)
    var headers: [String: String]? { get } // İsteğin başlıkları (örn: Authorization)
    associatedtype ReturnType: Codable // Dönen verinin tipi, Codable protokolüne uygun olmalı
}

// NetworkRequest protokolü için varsayılan ayarlar ve yardımcı metodlar
extension NetworkRequest {
    // Varsayılan değerler
    var method: HttpMethod { return .get } // Varsayılan HTTP yöntemi: GET
    var contentType: String { return "application/json" } // Varsayılan içerik türü: application/json
    var queryParams: [String: Any]? { return nil } // Varsayılan olarak sorgu parametresi yok
    var body: [String: Any]? { return nil } // Varsayılan olarak istek gövdesi yok
    var headers: [String: String]? { return nil } // Varsayılan olarak özel başlık yok

    /// HTTP sözlüğünü JSON veri nesnesine dönüştürür
    /// - Parameter params: HTTP parametreleri sözlüğü
    /// - Returns: Kodlanmış JSON veri
    private func requestBodyFrom(params: [String: Any]?) -> Data? {
        // Eğer parametre yoksa, nil döndür
        guard let params = params else { return nil }
        // Parametreleri JSON veri formatına dönüştür
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            return nil
        }
        return httpBody // JSON verisi olarak döndür
    }

    /// Sorgu parametrelerini URLQueryItem formatına çevirir
    /// - Parameter queryParams: Sorgu parametreleri sözlüğü
    /// - Returns: URLQueryItem listesi
    func addQueryItems(queryParams: [String: Any]?) -> [URLQueryItem]? {
        // Eğer sorgu parametreleri yoksa, nil döndür
        guard let queryParams = queryParams else {
            return nil
        }
        // Sorgu parametrelerini URLQueryItem'lara dönüştür
        return queryParams.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
    }

    /// İsteği standart bir URLRequest'e dönüştürür
    /// - Parameter baseURL: Kullanılacak API taban URL'si
    /// - Returns: Kullanıma hazır bir URLRequest
    func asURLRequest(baseURL: String) -> URLRequest? {
        // URLComponents kullanarak temel URL'yi oluşturur
        guard var urlComponents = URLComponents(string: baseURL) else { return nil }
        // URL'nin yolunu (path) ayarlar
        urlComponents.path = "\(urlComponents.path)\(path)"

        // API key'i query parametresi olarak ekle
        var queryItems = urlComponents.queryItems ?? []
        queryItems.append(URLQueryItem(name: "api_key", value: ENV.API_KEY))
        // Eğer SESSION_ID boş değilse, onu da query'e ekle
        if !ENV.SESSION_ID.isEmpty {
            queryItems.append(URLQueryItem(name: "session_id", value: ENV.SESSION_ID))
        }
        urlComponents.queryItems = queryItems

        // Nihai URL'yi oluşturur
        guard let finalURL = urlComponents.url else { return nil }
        // URLRequest nesnesi oluşturur
        var request = URLRequest(url: finalURL)
        // HTTP yöntemini ayarlar (GET, POST, vb.)
        request.httpMethod = method.rawValue
        // Gövdeyi (body) JSON formatında ayarlar
        request.httpBody = requestBodyFrom(params: body)
        // Başlıkları (headers) ayarlar
        request.allHTTPHeaderFields = headers

        /// Ortak başlıklar burada ayarlanabilir
        /// Örneğin: yetkilendirme başlığı (API secret key), içerik türü vb.
        request.setValue("Bearer \(ENV.API_KEY)", forHTTPHeaderField: HTTPHeaderField.authorization.rawValue) // Authorization başlığı
        request.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue) // Accept başlığı
        request.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue) // Content-Type başlığı

        return request // Hazır URLRequest döndürülür
    }
}
