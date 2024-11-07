//
//  BookmarkViewController.swift
//  FindMyBook
//
//  Created by Harshvardhan Sharma on 07/11/24.
//

import UIKit

class BookmarkViewController: UIViewController {
    
    private var books: [Book] = AppDefaults.shared.bookmarkedBooks ?? []
    
    private let backButton : UIButton = {
        let backButton = UIButton()
        backButton.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        backButton.tintColor = .black
        backButton.translatesAutoresizingMaskIntoConstraints = false
        return backButton
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Bookmarks"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bookmarkedTableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let noResultsView : NoResultsView = {
        let view = NoResultsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
    }
}

//MARK: Helper functions
extension BookmarkViewController {
    
    private func setupUI() {
        
        view.backgroundColor = .white
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(bookmarkedTableView)
        view.addSubview(noResultsView)

        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        bookmarkedTableView.dataSource = self
        bookmarkedTableView.delegate = self
        bookmarkedTableView.register(BookTableViewCell.self, forCellReuseIdentifier: "BookCell")

        NSLayoutConstraint.activate([
            // Back Button at the top left
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 24),  // Adjusted to make it visible properly
            backButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Title Label at the top center
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 16),  // Center it horizontally
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            
            // TableView below the title
            bookmarkedTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            bookmarkedTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bookmarkedTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bookmarkedTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            //No result view in middle of view
            noResultsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noResultsView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        updateNoResultsView()
    }
    
    private func updateNoResultsView() {
        if books.isEmpty {
            // No results, show the custom view and hide tableView
            noResultsView.isHidden = false
            bookmarkedTableView.isHidden = true
            noResultsView.updateMessage("Add books in your favorite list\nto see them here")
            
        } else {
            //hide the noResultsView and show the tableView
            noResultsView.isHidden = true
            bookmarkedTableView.isHidden = false
        }
    }

}

//MARK: Tableview Delegate
extension BookmarkViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookTableViewCell
        let book = books[indexPath.row]
        cell.configure(with: book)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let book = books[indexPath.row]
        
        let bookmarkAction = UIContextualAction(style: .normal, title: "Unbookmark") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            self.removeBookmark(book)
            completionHandler(true)
            tableView.reloadData()
        }
        
        bookmarkAction.backgroundColor = .black
        bookmarkAction.image = UIImage(systemName: "bookmark.slash.fill")
        
        let configuration = UISwipeActionsConfiguration(actions: [bookmarkAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    private func removeBookmark(_ book: Book) {
        var bookmarkedBooks : [Book] = AppDefaults.shared.bookmarkedBooks ?? []
        bookmarkedBooks.removeAll { $0.title == book.title }
        AppDefaults.shared.bookmarkedBooks = bookmarkedBooks
        books = bookmarkedBooks
        updateNoResultsView()
    }
}

//MARK: @objc functions
extension BookmarkViewController {
    @objc
    private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
