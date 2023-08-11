import SnapKit
import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties

    var indexPath: IndexPath?
    weak var delegate: MovieViewModelDelegate?

    private lazy var posterImageView: UIImageView = {
        let posterImageView = UIImageView()
        return posterImageView
    }()

    private lazy var poster: UILabel = {
        let poster = UILabel()
        return poster
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.robotoRegular.withSize(14)
        label.text = "Title: "
        label.numberOfLines = 2
        label.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        label.textAlignment = .left
        return label
    }()

    private lazy var releaseYearLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.robotoRegular.withSize(14)
        label.text = "Release "
        label.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        label.textAlignment = .left
        return label
    }()

    private lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.robotoRegular.withSize(14)
        label.text = "Genre: "
        label.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        label.textAlignment = .left
        return label
    }()

    private lazy var directorLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.robotoRegular.withSize(14)
        label.text = "Director: "
        label.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        label.textAlignment = .left
        return label
    }()

    private lazy var movieInfosStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .leading
        sv.distribution = .fillEqually
        return sv
    }()

    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "minus.circle.fill")
        button.tintColor = .red
        button.contentMode = .scaleAspectFill
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // MARK: - Public Method

    func configure(with movie: Movie) {
        if let posterURL = movie.posterURL {
            let image = UIImage(named: posterURL)
            poster.isHidden = true
            posterImageView.isHidden = false
            posterImageView.image = image

        } else {
            poster.text = "?"
            poster.font = AppFont.robotoBold.withSize(50)
            poster.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            poster.backgroundColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
            poster.textAlignment = .center
            posterImageView.isHidden = true
            poster.isHidden = false
        }

        titleLabel.text = "Title: \(movie.title)"
        releaseYearLabel.text = "Release: \(movie.releaseYear)"
        genreLabel.text = "Genre: \(movie.genre)"
        directorLabel.text = "Director: \(movie.director)"
    }

    // MARK: - Private Methods

    private func setupView() {
        movieInfosStackView.addArrangedSubviews(titleLabel, releaseYearLabel, genreLabel, directorLabel)
        contentView.addSubviews(posterImageView, poster, movieInfosStackView, deleteButton)
        layer.cornerRadius = 10
        layer.borderWidth = 0.7
        layer.borderColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        alpha = 0.8
        setupLayout()
    }

    private func setupLayout() {
        deleteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.height.equalTo(32)
            make.width.equalTo(32)
        }
        posterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.width.equalTo(100)
        }
        poster.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.width.equalTo(100)
        }
        movieInfosStackView.snp.makeConstraints { make in
            make.top.equalTo(poster.snp.top)
            make.leading.equalTo(poster.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(poster.snp.bottom)
        }
    }

    // MARK: - Actions

    @objc func deleteButtonTapped() {
        guard let indexPath = indexPath else { return }
        delegate?.deleteMovie(at: indexPath)
    }
}
