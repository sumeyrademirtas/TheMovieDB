//
//  CollectionViewTableViewCell.swift
//  TheMovieDB
//
//  Created by Sümeyra Demirtaş on 11.09.2024.
//

import UIKit

class CollectionViewTableViewCell: UITableViewCell {
    static let identifier = "CollectionViewTableViewCell"
    
    private var movieViewModel: MovieListViewModel? = nil
    private var tvSeriesViewModel: TvSeriesListViewModel? = nil
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
 
        return collectionView
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        contentView.addSubview(posterImageView)

        collectionView.delegate = self
        collectionView.dataSource = self
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    
    
    // MARK: - Configure
    
    // CollectionViewTableViewCell içinde
    public func configure(with movieViewModel: MovieListViewModel?, tvSeriesViewModel: TvSeriesListViewModel?) {
        if let movieViewModel = movieViewModel {
                self.movieViewModel = movieViewModel
                self.tvSeriesViewModel = nil // TV serisini temizleyelim, sadece filmler gösterilecek
            } else if let tvSeriesViewModel = tvSeriesViewModel {
                self.tvSeriesViewModel = tvSeriesViewModel
                self.movieViewModel = nil // Filmleri temizleyelim, sadece TV serileri gösterilecek
            }
        collectionView.reloadData() // CollectionView'ı yeni verilerle yeniliyoruz
    }
    

    
    public func configure(with viewModel: DetailViewModel) {
        // Posteri URL'den yüklemek için bir fonksiyon çağırıyoruz
        if let posterPath = viewModel.tvposterPath ?? viewModel.movieposterPath {
            print("Poster path: \(posterPath)")
            loadImage(from: "https://image.tmdb.org/t/p/w500\(posterPath)")
            collectionView.reloadData() 
        } else {
            print("Poster path is nil")
        }
    }
    
    // MARK: - Image Loading
    

        private func loadImage(from urlString: String) {
            print("Loading image from URL: \(urlString)") // URL'yi kontrol edin
            guard let url = URL(string: urlString) else { return }
            print("Invalid URL: \(urlString)")
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                if let error = error {
                    print("Error loading image: \(error)")
                    return
                }
                guard let data = data, let image = UIImage(data: data) else {
                    print("Invalid image data")
                    return
                }
                DispatchQueue.main.async {
                    self?.posterImageView.image = image
                }
            }
            task.resume()
        }
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //her hücre (cell) için hangi içeriğin gösterileceğini belirler
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Koleksiyon görünümünden tekrar kullanılabilir bir hücre alıyoruz.
        // PosterCollectionViewCell tipinde bir hücre döndürülmezse, boş bir UICollectionViewCell döndürülür.
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as? PosterCollectionViewCell else {
            // Eğer hücre doğru şekilde deque yapılamazsa, varsayılan boş bir hücre döndürülür.
            return UICollectionViewCell()
        }
        
        if let movieViewModel = movieViewModel {
                let movie = movieViewModel.movies[indexPath.row]
                let movieDetailViewModel = DetailViewModel(movie: movie)
                cell.configure(with: movieDetailViewModel) // Filmleri göster
            } else if let tvSeriesViewModel = tvSeriesViewModel {
                let tvSeries = tvSeriesViewModel.tvSeries[indexPath.row]
                let tvSeriesDetailViewModel = DetailViewModel(tvserie: tvSeries)
                cell.configure(with: tvSeriesDetailViewModel) // TV serilerini göster
            }
        
        // Yapılandırılmış hücreyi geri döndürerek koleksiyon görünümüne eklenmesini sağlıyoruz.
        return cell
    }
    
    //her bir section (bölüm) için kaç adet öğe (item) olduğunu belirtir
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movieViewModel = movieViewModel {
                return movieViewModel.movies.count
            } else if let tvSeriesViewModel = tvSeriesViewModel {
                return tvSeriesViewModel.tvSeries.count
            }
            return 0
        

    }
}
