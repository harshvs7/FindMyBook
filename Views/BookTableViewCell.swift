//
//  BookTableViewCell.swift
//  FindMyBook
//
//  Created by Harshvardhan Sharma on 07/11/24.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    
    private let viewModel = HomeViewModel()
    private var genres: [String] = []
    
    let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let genreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("View Genres", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.link, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    let publicationYearLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let ratingsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Configure the cell layout and add constraints
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(coverImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(genreButton)
        contentView.addSubview(publicationYearLabel)
        contentView.addSubview(ratingsLabel)
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            // Cover Image on the left
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            coverImageView.widthAnchor.constraint(equalToConstant: 60),
            coverImageView.heightAnchor.constraint(equalToConstant: 90),
            
            // Title next to the cover image
            titleLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            // Author name below the title
            authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            // Genre button below the author
            genreButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            genreButton.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 4),
            genreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            // Publication year below the genre button
            publicationYearLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            publicationYearLabel.topAnchor.constraint(equalTo: genreButton.bottomAnchor, constant: 4),
            publicationYearLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            // Ratings label below the publication year
            ratingsLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            ratingsLabel.topAnchor.constraint(equalTo: publicationYearLabel.bottomAnchor, constant: 4),
            ratingsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            // Description label at the bottom
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: ratingsLabel.bottomAnchor, constant: 4),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        genreButton.addTarget(self, action: #selector(showGenreList), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with book: Book) {
        titleLabel.text = book.title
        authorLabel.text = "Author(s): \(book.author)"
        genres = book.genre
        publicationYearLabel.text = "Published: \(book.publicationYear)"
        ratingsLabel.text = "Rating: \(book.ratingsAverage) | (\(book.ratingsCount) reviews)"
        descriptionLabel.text = book.description
        
        viewModel.fetchBookCoverImage(coverID: book.coverID) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.coverImageView.image = image
            }
        }
    }
    
    @objc private func showGenreList() {
        guard let viewController = self.window?.rootViewController else { return }
        
        let alertController = UIAlertController(title: "Genres", message: nil, preferredStyle: .actionSheet)
        
        for genre in genres {
            let action = UIAlertAction(title: genre, style: .default, handler: nil)
            alertController.addAction(action)
        }
        
        // Add a close button to dismiss the action sheet
        let closeAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        alertController.addAction(closeAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
