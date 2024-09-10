//
//  NetworkClient.swift
//  TheMovieDB
//
//  Created by Sümeyra Demirtaş on 9.09.2024.
//

import Combine
import Foundation

/// Ağ taleplerini işleyen bir ağ istemcisi yapısı.
enum NetworkClient {
    // Ağ isteklerini işlemek için kullanılan statik bir network dispatcher örneği.
    static var networkDispatcher: NetworkDispatcher = .init()

    /// Bir ağ isteği yapar ve Combine publisher'ı döndürür.
    /// - Parameter request: Yapılacak ağ isteği.
    /// - Returns: Decode edilmiş veriyi veya bir hatayı içeren Combine publisher'ı.
    static func dispatch<R: NetworkRequest>(_ request: R) -> AnyPublisher<R.ReturnType, NetworkRequestError> {
        // Ağ isteğini temel URL ile bir URL isteğine dönüştürmeye çalışır.
        guard let urlRequest = request.asURLRequest(baseURL: NetworkConstants.baseURL) else {
            // Eğer URL isteği oluşturma başarısız olursa, Combine'ın 'Fail' publisher'ı ile bir 'badRequest' hatası döndürür.
            return Fail(outputType: R.ReturnType.self, failure: NetworkRequestError.badRequest)
                .eraseToAnyPublisher()
        }

        // Beklenen publisher türü için bir alias tanımlar. Bu, dönecek olan veri veya hatayı temsil eder.
        typealias RequestPublisher = AnyPublisher<R.ReturnType, NetworkRequestError>

        // URL isteğini dispatcher aracılığıyla gönderir ve bir publisher döner.
        let requestPublisher: RequestPublisher = networkDispatcher.dispatch(request: urlRequest)

        // Publisher türünü 'AnyPublisher' olarak soyutlar, böylece daha esnek bir şekilde kullanılabilir.
        return requestPublisher
            .eraseToAnyPublisher()
    }
}
