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

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: "CollectionViewTableViewCell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension ListwithPosterVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // 1 Popular Moview, 2 Popular Tv Series
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }

        if indexPath.section == 0 {
            // 0. section Movies için, movieViewModel'i geçiriyoruz
            cell.configure(with: movieViewModel, tvSeriesViewModel: nil)
        } else if indexPath.section == 1 {
            // 1. section TV Series için, tvSeriesViewModel'i geçiriyoruz
            cell.configure(with: nil, tvSeriesViewModel: tvSeriesViewModel)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Popular Movies" : "Popular Tv Series"
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
    }
}
