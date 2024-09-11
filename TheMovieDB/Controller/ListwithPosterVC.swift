//
//  ListwithPosterVC.swift
//  TheMovieDB
//
//  Created by Sümeyra Demirtaş on 11.09.2024.
//

import UIKit

final class ListwithPosterVC: UIViewController {
    // MARK: - Properties

    private var movieViewModel = MovieListViewModel()
    private var tvSeriesViewModel = TvSeriesListViewModel()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fetchData()
        setupCollectionView()
    }

    private func fetchData() {
        movieViewModel.fetchMovies()
        tvSeriesViewModel.fetchTvSeries()

        movieViewModel.didFetchMovies = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }

        tvSeriesViewModel.didFetchTvSeries = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }

    // CollectionView'i ayarlama fonksiyonu
    private func setupCollectionView() {
        view.addSubview(collectionView)

        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)

        // AutoLayout ile koleksiyonun tam ekran olmasını sağla
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource ve UICollectionViewDelegate

extension ListwithPosterVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2 // "Popular Movies",  "Popular TV Series"
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Eğer section 0 ise, film sayısını döndür
        if section == 0 {
            return movieViewModel.movies.count
        }
        // Eğer section 1 ise, TV dizisi sayısını döndür
        else {
            return tvSeriesViewModel.tvSeries.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as? PosterCollectionViewCell else {
            return UICollectionViewCell()
        }
        if indexPath.section == 0 {
            let movie = movieViewModel.movies[indexPath.row]
            let movieViewModel = DetailViewModel(movie: movie) // Filmin ViewModel'i
            cell.configure(with: movieViewModel) // ViewModel'i hücreye gönderiyoruz
        } else {
            let tvSeries = tvSeriesViewModel.tvSeries[indexPath.row]
            let tvSeriesViewModel = DetailViewModel(tvserie: tvSeries) // Dizinin ViewModel'i
            cell.configure(with: tvSeriesViewModel) // ViewModel'i hücreye gönderiyoruz
        }
        return cell
    }

    // Her bir section için header (başlık)
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.identifier, for: indexPath) as? HeaderView else {
            return UICollectionReusableView()
        }

        // Section'a göre başlık belirle
        if indexPath.section == 0 {
            header.configure(with: "Popular Movies")
        } else {
            header.configure(with: "Popular TV Series")
        }

        return header
    }

    // Header'ın yüksekliği
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }

    // Hücre boyutları
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 180) // Poster boyutları
    }

    // Section'lar arası boşluk
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
