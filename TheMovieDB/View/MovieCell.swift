//
//  MovieCell.swift
//  TheMovieDB
//
//  Created by Sümeyra Demirtaş on 9.09.2024.
//

import UIKit

class MovieCell: UITableViewCell {
    static let identifier = "MovieCell"

    // UILabels for name and username
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .label
        return label
    }()

    private let voteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
        return label
    }()

    // Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    // Gerekli olduğunda storyboard üzerinden başlatmak için kullanılan init. Ama hucreler sadece kod ile olusturuldu.
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Setup the UI components in the cell
    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, voteLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }

    // Configure the cell with a view model
    func configure(with viewModel: MovieViewModel) {
        nameLabel.text = viewModel.title
        voteLabel.text = String(format: "%.1f", viewModel.voteAverage)
    }
}
