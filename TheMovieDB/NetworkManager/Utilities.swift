//
//  Utilities.swift
//  TheMovieDB
//
//  Created by Sümeyra Demirtaş on 9.09.2024.
//

import Foundation

/// ENV: Ortam değerlerini almak için kullanılan bir global değişken.
/// Bu değişken, derleme moduna göre (DEBUG veya RELEASE) farklı yapılandırma dosyalarını yükleyebilir.
/// Şu an hem DEBUG hem RELEASE için aynı `ConfigEnv` kullanılıyor, ancak isterseniz farklı ortam dosyaları kullanabilirsiniz.
var ENV: ApiKeyable {
    #if DEBUG
    return ConfigEnv() // DEBUG modunda ConfigEnv kullanılıyor
    #else
    // Farklı bir ortam dosyası kullanmak isterseniz burada değiştirebilirsiniz
    return ConfigEnv() // RELEASE modunda da aynı ConfigEnv kullanılıyor
    #endif
}

/// ApiKeyable protokolü, API ile ilgili anahtar bilgilerini almak için bir şablon oluşturur.
protocol ApiKeyable {
    var API_KEY: String { get } // API anahtarını almak için bir özellik
    var API_HOST: String { get } // API hostunu almak için bir özellik
    var SESSION_ID: String { get }
    var ACCOUNT_ID: String { get }
}

/// BaseEnv sınıfı, plist dosyasını okumak için temel işlevselliği içerir.
class BaseEnv {
    // Plist dosyasındaki anahtarları temsil eden bir enum
    enum Key: String {
        case API_KEY // API anahtarı
        case API_HOST // API hostu
    }

    let dict: NSDictionary // plist dosyasındaki veriler bu sözlük içinde tutulacak

    // BaseEnv yapıcısı, plist dosyasını yüklemek için kullanılır
    init(resourceName: String) {
        // plist dosyasının yolunu buluyor ve dosyayı açıp içeriğini NSDictionary olarak yüklüyor
        guard let filePath = Bundle.main.path(forResource: resourceName, ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath)
        else {
            // Eğer plist dosyası bulunamazsa, uygulama çöker
            fatalError("Couldn't find file '\(resourceName)' plist")
        }
        self.dict = plist // plist içeriğini sözlüğe atıyor
    }
}

/// ConfigEnv, "Config" adlı plist dosyasını okuyarak API bilgilerini sağlayan sınıf.
/// Bu sınıf, BaseEnv'den miras alır ve ApiKeyable protokolünü uygular.
class ConfigEnv: BaseEnv, ApiKeyable {
    // ConfigEnv, "Config" adlı plist dosyasını yüklemek için kullanılır
    init() {
        super.init(resourceName: "Config") // Config adında plist dosyasını açıyor
    }

    // API_KEY özelliği, plist dosyasındaki API_KEY anahtarını okuyarak döner
    var API_KEY: String {
        dict.object(forKey: Key.API_KEY.rawValue) as? String ?? "" // Eğer anahtar bulunamazsa boş bir string döner
    }

    // API_HOST özelliği, plist dosyasındaki API_HOST anahtarını okuyarak döner
    var API_HOST: String {
        dict.object(forKey: Key.API_HOST.rawValue) as? String ?? "" // Eğer anahtar bulunamazsa boş bir string döner
    }

    var SESSION_ID: String {
        dict.object(forKey: "SESSION_ID") as? String ?? ""
    }

    var ACCOUNT_ID: String {
        dict.object(forKey: "ACCOUNT_ID") as? String ?? ""
    }
}
