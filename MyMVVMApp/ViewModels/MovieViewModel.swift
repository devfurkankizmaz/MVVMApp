import UIKit

class MovieViewModel {
    private let apiService: APIServiceProtocol

    private var movies: [Movie] = []
    weak var delegate: MovieViewModelDelegate?

    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }

    func countOfMovies() -> Int {
        return movies.count
    }

    func getMovie(_ row: Int) -> Movie {
        return movies[row]
    }

    func fetchMovies() {
        delegate?.updateSpinner(true)
        apiService.fetchMovie { [weak self] success, movies, err in
            if success {
                self?.movies = movies
                self?.delegate?.moviesFetched()
                self?.delegate?.updateSpinner(false)
            } else {
                guard let errMsg = err else { return }
                self?.delegate?.errorOccurred(error: errMsg.rawValue)
                self?.delegate?.updateSpinner(false)
            }
        }
    }

    func deleteMovie(at indexPath: IndexPath) {
        movies.remove(at: indexPath.row)
        delegate?.moviesFetched()
    }
}

protocol MovieViewModelDelegate: AnyObject {
    func moviesFetched()
    func deleteMovie(at indexPath: IndexPath)
    func errorOccurred(error: String)
    func updateSpinner(_ animate: Bool)
}
