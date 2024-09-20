//
//  MovieDetailView.swift
//  TheMovieDB
//
//  Created by Sümeyra Demirtaş on 10.09.2024.
//

import UIKit

// MARK: - MovieDetailView

final class MovieDetailView: UIView {
    // MARK: - Properties

    // ScrollView: İçerik uzun olduğunda kaydırma işlemi yapmak için kullanılır
    private let scrollView = UIScrollView()
    // contentView: Tüm UI bileşenlerinin içinde bulunduğu ana view
    private let contentView = UIView()
    
    private let titleLabel = UILabel()
    private let releaseDateLabel = UILabel()
    private let ratingLabel = UILabel()
    private let originalLanguageLabel = UILabel()
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true // Görüntünün kenarları taşmaması için kullanıldı
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupScrollView()
        setupUI()
    }
    
    @available(*, unavailable) // bu satir alttaki fonksiyonu devre disi birakmaya yariyor. * butun platformlari ifade ediyor.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ScrollView Setup

    private func setupScrollView() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
           
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
               
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }
    
    // MARK: - UI Setup

    private func setupUI() {
        let titleRow = createRow(iconName: "film", title: "Name", label: titleLabel)
        let originalLanguageRow = createRow(iconName: "globe", title: "Original Language", label: originalLanguageLabel)
        let releaseDateRow = createRow(iconName: "calendar", title: "Release Date", label: releaseDateLabel)
        let ratingRow = createRow(iconName: "star.fill", title: "Rating", label: ratingLabel)
        let overviewRow = createRow(iconName: "text.justify", title: "Overview:", label: overviewLabel)
        
        let stackView = UIStackView(arrangedSubviews: [posterImageView, titleRow, originalLanguageRow, releaseDateRow, ratingRow, overviewRow])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            posterImageView.heightAnchor.constraint(equalToConstant: 450),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20) // contentView'in altına sabitliyoruz
        ])
    }
    
    private func createRow(iconName: String, title: String, label: UILabel) -> UIStackView {
        let iconImageView = UIImageView(image: UIImage(systemName: iconName))
        iconImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        label.textAlignment = .right
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.numberOfLines = 0
        // Adding width constraints to the label to allow for line wrapping
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width * 0.4) // Set max width of label
        ])

        let stackView = UIStackView(arrangedSubviews: [iconImageView, titleLabel, label])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 16
        return stackView
    }
    
    // MARK: - Configure

    // ViewModel'den alınan verilerle UI bileşenlerini güncelleyen fonksiyon
    public func configure(with viewModel: DetailViewModel) {
        titleLabel.text = viewModel.movietitle
        originalLanguageLabel.text = viewModel.movieoriginalLanguage
        releaseDateLabel.text = viewModel.moviereleaseDate
        ratingLabel.text = viewModel.movievoteAverage
        overviewLabel.text = viewModel.movieoverview
        
        // Posteri URL'den yüklemek için bir fonksiyon çağırıyoruz
        if let posterPath = viewModel.movieposterPath {
            loadImage(from: "https://image.tmdb.org/t/p/w500\(posterPath)")
        }
    }
    
    // MARK: - Image Loading

    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.posterImageView.image = image
            }
        }
        task.resume()
    }
}
