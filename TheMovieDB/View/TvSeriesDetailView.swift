//
//  TvSeriesDetailView.swift
//  TheMovieDB
//
//  Created by Sümeyra Demirtaş on 10.09.2024.
//

import UIKit

// MARK: - TvSeriesDetailView

final class TvSeriesDetailView: UIView {
    // MARK: - Properties
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let nameLabel = UILabel()
    private let originalLanguageLabel = UILabel()
    private let firstAirDateLabel = UILabel()
    private let ratingLabel = UILabel()
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
        imageView.clipsToBounds = true
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
    
    @available(*, unavailable)
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
               scrollView.topAnchor.constraint(equalTo: self.topAnchor),
               scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
               scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
               scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
               
               contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
               contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
               contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
               contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
               contentView.widthAnchor.constraint(equalTo: self.widthAnchor)
           ])
       }
    
    // MARK: - UI Setup

    private func setupUI() {
        let nameRow = createRow(iconName: "tv", title: "Name", label: nameLabel)
        let originalLanguageRow = createRow(iconName: "globe", title: "Original Language", label: originalLanguageLabel)
        let firstAirDateRow = createRow(iconName: "calendar", title: "First Air Date", label: firstAirDateLabel)
        let ratingRow = createRow(iconName: "star.fill", title: "Rating", label: ratingLabel)
        let overviewRow = createRow(iconName: "text.justify", title: "Overview:", label: overviewLabel)
        
        let stackView = UIStackView(arrangedSubviews: [posterImageView, nameRow, originalLanguageRow, firstAirDateRow, ratingRow, overviewRow])
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

    public func configure(with viewModel: DetailViewModel) {
        nameLabel.text = viewModel.tvname
        originalLanguageLabel.text = viewModel.tvoriginalLanguage
        firstAirDateLabel.text = viewModel.tvfirstAirDate
        ratingLabel.text = viewModel.tvvoteAverage
        overviewLabel.text = viewModel.tvoverview

        
        // Posteri URL'den yüklemek için bir fonksiyon çağırıyoruz
        if let posterPath = viewModel.tvposterPath {
            loadImage(from: "https://image.tmdb.org/t/p/w500\(posterPath)")
        }
    }
    
    // MARK: - Image Loading
       private func loadImage(from urlString: String) {
           guard let url = URL(string: urlString) else { return }
           let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
               guard let data = data, error == nil, let image = UIImage(data: data) else { return }
               DispatchQueue.main.async {
                   self?.posterImageView.image = image
               }
           }
           task.resume()
       }
}
