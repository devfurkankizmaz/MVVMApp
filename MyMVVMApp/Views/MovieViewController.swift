import SnapKit
import UIKit

class MovieViewController: UIViewController {
    // MARK: - Properties

    private lazy var movieCollectionView: UICollectionView = {
        // Flow Layout ile CollectionView'daki hücrelerin nasıl düzenleneceğini belirliyoruz.
        let flowLayout = UICollectionViewFlowLayout()

        // Hücreler arası yatay boşluk
        flowLayout.minimumLineSpacing = 16

        // Hücreler arası dikey boşluk
        flowLayout.minimumInteritemSpacing = 16

        // Hücreleri kaydıracağımız yönü belirliyoruz.
        flowLayout.scrollDirection = .vertical

        // Section kısmının içerisine doğru boşluk ekler (padding)
        flowLayout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        cv.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "movieIdentifier")
        return cv
    }()

    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
        spinner.hidesWhenStopped = true
        return spinner
    }()

    private lazy var viewModel = MovieViewModel()

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel.delegate = self
        viewModel.fetchMovies()
    }

    // MARK: - Private Methods

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubviews(movieCollectionView, spinner)
        setupLayout()
    }

    private func setupLayout() {
        movieCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 100, left: 16, bottom: 16, right: 16))
        }
        spinner.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}

// MARK: - Extensions

extension MovieViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.width - 40, height: 200)
        return size
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.countOfMovies()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieIdentifier", for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }

        let movie = viewModel.getMovie(indexPath.row)
        cell.delegate = self
        cell.indexPath = indexPath
        cell.configure(with: movie)
        return cell
    }
}

extension MovieViewController: MovieViewModelDelegate {
    func moviesFetched() {
        DispatchQueue.main.async {
            self.movieCollectionView.reloadData()
        }
    }

    func deleteMovie(at indexPath: IndexPath) {
        showDeleteConfirmationAlert(completion: { confirmed in
            if confirmed {
                self.viewModel.deleteMovie(at: indexPath)
            }
        })
    }

    func errorOccurred(error: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            self.spinner.stopAnimating()
        }
    }

    func updateSpinner(_ animate: Bool) {
        DispatchQueue.main.async {
            if animate {
                self.spinner.startAnimating()
            } else {
                self.spinner.stopAnimating()
            }
        }
    }
}
