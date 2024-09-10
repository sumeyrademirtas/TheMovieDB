//
//  DetailsVC.swift
//  TheMovieDB
//
//  Created by Sümeyra Demirtaş on 10.09.2024.
//

import UIKit

final class DetailsVC: UIViewController {
    // Movie ve TvSeries için görünümler
    private let movieDetailView = MovieDetailView()
    private let tvSeriesDetailView = TvSeriesDetailView()

    // Enum ya da geçilecek veriye göre ayırt edeceğiz
    private var mediaType: MediaType? // ContentType enum veya başka bir veri türü
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        configureView()
        setupFavoriteButton()
        navigationController?.setNavigationBarHidden(false, animated: false)

    }
    
    private func setupFavoriteButton() {
           guard let mediaType = mediaType else { return }
           let isFavourite = FavouriteManager.shared.isFavourite(mediaType)
           let buttonIcon = isFavourite ? "heart.fill" : "heart"
           let favoriteButton = UIBarButtonItem(
               image: UIImage(systemName: buttonIcon),
               style: .plain,
               target: self,
               action: #selector(favoriteButtonTapped)
           )
           navigationItem.rightBarButtonItem = favoriteButton
       }
    
    @objc private func favoriteButtonTapped() {
            guard let mediaType = mediaType else { return }
            
            if FavouriteManager.shared.isFavourite(mediaType) {
                FavouriteManager.shared.removeFromFavourites(mediaType)
                NotificationCenter.default.post(name: NSNotification.Name("favouriteUpdated"), object: nil)
            } else {
                FavouriteManager.shared.addToFavourites(mediaType)
                NotificationCenter.default.post(name: NSNotification.Name("favouriteUpdated"), object: nil)
            }
            
            // Favori butonunu güncelle
            setupFavoriteButton()
        }
    
    private func setupView() {
        // Default olarak her iki view'i gizliyoruz
        movieDetailView.translatesAutoresizingMaskIntoConstraints = false
        tvSeriesDetailView.translatesAutoresizingMaskIntoConstraints = false
        movieDetailView.isHidden = true
        tvSeriesDetailView.isHidden = true
        view.addSubview(movieDetailView)
        view.addSubview(tvSeriesDetailView)
        
        NSLayoutConstraint.activate([
            movieDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            movieDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tvSeriesDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tvSeriesDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tvSeriesDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tvSeriesDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // Bu fonksiyon, DetailsVC'deki mediaType'ı ayarlamak için kullanılır.
    // Dışarıdan bir MediaType değeri alınır ve mediaType değişkenine atanır.
    func configure(with mediaType: MediaType) {
        self.mediaType = mediaType
    }
        
    // Bu fonksiyon, view'daki bileşenleri doğru medya türüne göre yapılandırır.
    // mediaType'ın içeriği doğrultusunda (Movie mi, TV Series mi) hangi detay view'in gösterileceğini belirler.
    func configureView() {
        // Eğer mediaType değeri boş (nil) ise, geri döneriz ve fonksiyon devam etmez.
        guard let contentType = mediaType else { return }
        
        switch contentType {
        case .movie(let movie):
            movieDetailView.isHidden = false
            let movieViewModel = DetailViewModel(movie: movie)
            movieDetailView.configure(with: movieViewModel)
            
        case .tvSeries(let tvSeries):
            tvSeriesDetailView.isHidden = false
            let tvSeriesViewModel = DetailViewModel(tvserie: tvSeries)
            tvSeriesDetailView.configure(with: tvSeriesViewModel)
        }
    }
}
