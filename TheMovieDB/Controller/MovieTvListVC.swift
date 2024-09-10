//
//  MovieTvListVC.swift
//  TheMovieDB
//
//  Created by Sümeyra Demirtaş on 9.09.2024.
//

import UIKit

class MovieTvListVC: UIViewController {
    // MARK: - Properties

    private var movieViewModel = MovieListViewModel()
    private var tvSeriesViewModel = TvSeriesListViewModel()
    

    // TableView to display movies and TV series
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
        tableView.register(TvSeriesCell.self, forCellReuseIdentifier: TvSeriesCell.identifier)
        return tableView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Movie and TV List"
        setupTableView()
        fetchData()
    }

    private func fetchData() {
        movieViewModel.fetchMovies()
        tvSeriesViewModel.fetchTvSeries()

        movieViewModel.didFetchMovies = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }

        tvSeriesViewModel.didFetchTvSeries = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension MovieTvListVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // 1 for Movies, 1 for TV Series
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return movieViewModel.movies.count
        } else {
            return tvSeriesViewModel.tvSeries.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else {
                return UITableViewCell()
            }
            let movieViewModel = movieViewModel.movieViewModel(at: indexPath.row)
            cell.configure(with: movieViewModel)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TvSeriesCell.identifier, for: indexPath) as? TvSeriesCell else {
                return UITableViewCell()
            }
            let tvSeriesViewModel = tvSeriesViewModel.tvSeriesViewModel(at: indexPath.row)
            cell.configure(with: tvSeriesViewModel)
            return cell
        }
    }

    // Section Headers
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Movies" : "TV Series"
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailVC = DetailsVC()
        
            if indexPath.section == 0 {
                print("Selected Movie: \(movieViewModel.movies[indexPath.row].title)")
                
                let selectedMovie = movieViewModel.movies[indexPath.row]
                // DetailsVC'ye filmi geçeriz. Burada, mediaType enum'unun movie case'ini kullanarak,
                // DetailsVC'deki configure fonksiyonuna film verisini gönderiyoruz.
                detailVC.configure(with: .movie(selectedMovie))

            
            } else {
                print("Selected TV Series: \(tvSeriesViewModel.tvSeries[indexPath.row].name)")
                
                let selectedTvSeries = tvSeriesViewModel.tvSeries[indexPath.row]
                
                // DetailsVC'ye TV dizisini geçeriz. Burada, mediaType enum'unun tvSeries case'ini kullanarak,
                // DetailsVC'deki configure fonksiyonuna TV dizisi verisini gönderiyoruz.
                detailVC.configure(with: .tvSeries(selectedTvSeries))
            }

            navigationController?.pushViewController(detailVC, animated: true)
    }
}
