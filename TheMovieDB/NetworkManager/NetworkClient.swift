//
//  NetworkClient.swift
//  TheMovieDB
//
//  Created by Sümeyra Demirtaş on 9.09.2024.
//

import Combine
import Foundation

/// Ağ taleplerini işleyen bir ağ istemcisi yapısı.
/// Bu yapı, API isteklerini yönetmek ve sonuçlarını Combine kullanarak geri döndürmek için kullanılır.
enum NetworkClient {
    // Ağ isteklerini işlemek için kullanılan statik bir network dispatcher örneği.
    // Bu dispatcher, URL isteğini yapar ve sonuçları döndürür.
    static var networkDispatcher: NetworkDispatcher = .init()

    /// Bir ağ isteği yapar ve Combine publisher'ı döndürür.
    /// - Parameter request: Yapılacak ağ isteği. NetworkRequest protokolüne uygun olmalıdır.
    /// - Returns: Decode edilmiş veriyi veya bir hatayı içeren Combine publisher'ı.
    static func dispatch<R: NetworkRequest>(_ request: R) -> AnyPublisher<R.ReturnType, NetworkRequestError> {
        
        // Ağ isteğini temel URL ile bir URL isteğine dönüştürmeye çalışır.
        // Eğer `request.asURLRequest()` başarısız olursa, bu durumda hata döndürülecektir.
        guard let urlRequest = request.asURLRequest(baseURL: NetworkConstants.baseURL) else {
            // Eğer URL isteği oluşturma başarısız olursa, Combine'ın 'Fail' publisher'ı ile bir 'badRequest' hatası döndürülür.
            return Fail(outputType: R.ReturnType.self, failure: NetworkRequestError.badRequest)
                .eraseToAnyPublisher() // Publisher'ın türünü soyutlayarak geri döner
        }

        // Beklenen publisher türü için bir alias tanımlar. Bu, dönecek olan veri veya hatayı temsil eder.
        typealias RequestPublisher = AnyPublisher<R.ReturnType, NetworkRequestError>

        // URL isteğini dispatcher aracılığıyla gönderir ve bir publisher döner.
        // Bu publisher, Combine yapısında bir veri akışı döner ve bu veri akışı URL yanıtı ile ilgilidir.
        let requestPublisher: RequestPublisher = networkDispatcher.dispatch(request: urlRequest)

        // Publisher türünü 'AnyPublisher' olarak soyutlar, böylece daha esnek bir şekilde kullanılabilir.
        return requestPublisher
            .eraseToAnyPublisher() // Publisher türünü soyut hale getirir, böylece bu fonksiyonun döndürdüğü veri esnek olur
    }
}
