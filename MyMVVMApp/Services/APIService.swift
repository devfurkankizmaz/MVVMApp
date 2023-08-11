import Foundation
 
enum APIError: String, Error {
    case noNetwork = "No Network"
    case serverOverload = "Server is overloaded"
    case permissionDenied = "You don't have permission"
}
 
protocol APIServiceProtocol {
    func fetchMovie(complete: @escaping (_ success: Bool, _ movies: [Movie], _ error: APIError?)->())
}
 
class APIService: APIServiceProtocol {
    // Simulate a long waiting for fetching
    func fetchMovie(complete: @escaping (_ success: Bool, _ movies: [Movie], _ error: APIError?)->()) {
        DispatchQueue.global().async {
            sleep(3)
            let path = Bundle.main.path(forResource: "Content", ofType: "json")!
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let movies = try! decoder.decode(Movies.self, from: data)
            complete(true, movies.movies, nil)
        }
    }
}
 
