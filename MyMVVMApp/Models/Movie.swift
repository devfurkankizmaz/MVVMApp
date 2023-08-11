import Foundation

struct Movies: Codable {
    let movies: [Movie]
}

// Codable protocolünü encoding, decoding işlemlerini kolaylaştırmak için kullanıyoruz.
// JSON'dan veri yapısına veya veri yapısından JSON'a dönüştürmeye yarar.
struct Movie: Codable {
    let title: String
    let releaseYear: Int
    let genre: String
    let director: String
    let posterURL: String?
}
