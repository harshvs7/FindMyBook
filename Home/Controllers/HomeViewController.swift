//
//  HomeViewController.swift
//  FindMyBook
//
//  Created by Harshvardhan Sharma on 07/11/24.
//

import UIKit

class HomeViewController : UIViewController {
    
    private var isLoading = false
    private var totalResults = 0
    private var viewModel = HomeViewModel()
    private var books = [Book]()
    
    private let bookmarkedTableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search for books"
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Find My Book"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bookmarkButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .red
        return button
    }()
    
    private let loader : UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()
    
    
    private let noResultsView : NoResultsView = {
        let view = NoResultsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showBookmarkAlert()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
    }
}

//MARK: Helper functions
extension HomeViewController {
    
    private func showBookmarkAlert() {
        self.showAlert("Bookmark", "Bookmark your favourite book by swiping left on the column.")
    }
    
    private func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(bookmarkButton)
        view.addSubview(searchBar)
        view.addSubview(bookmarkedTableView)
        view.addSubview(loader)
        view.addSubview(noResultsView)
        
        searchBar.delegate = self
        addDoneButtonOnKeyboard()
        bookmarkedTableView.delegate = self
        bookmarkedTableView.dataSource = self
        
        bookmarkedTableView.register(BookTableViewCell.self, forCellReuseIdentifier: "BookCell")
        bookmarkedTableView.allowsSelection = false
        
        bookmarkButton.addTarget(self, action: #selector(bookmarkTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            // Title Label at the top center
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            // Bookmark Button at the top right
            bookmarkButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            bookmarkButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Search Bar below title
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Results TableView below sortingButton
            bookmarkedTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            bookmarkedTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bookmarkedTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bookmarkedTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            //Loader in center of view
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            //No result view in middle of view
            noResultsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noResultsView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        updateNoResultsView()
    }
    
    private func updateNoResultsView() {
        if viewModel.books.isEmpty {
            // No results, show the custom view and hide tableView
            noResultsView.isHidden = false
            bookmarkedTableView.isHidden = true
            
            // Set the text depending on the searchBar's text to educate user to search
            if let searchText = searchBar.text, !searchText.isEmpty {
                noResultsView.updateMessage("No results found")
            } else {
                noResultsView.updateMessage("Search your favourite books")
            }
        } else {
            //hide the noResultsView and show the tableView
            noResultsView.isHidden = true
            bookmarkedTableView.isHidden = false
        }
    }
    
    // API CALL for books
    private func fetchBooks(query: String, offset: Int) {
        URLSession.shared.invalidateAndCancel()
        loader.startAnimating()
        viewModel.fetchBooks(query: query, offset: offset) { [weak self] success, errorMessage in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.loader.stopAnimating()
                if success {
                    if !self.viewModel.books.isEmpty {
                        self.bookmarkedTableView.reloadData()
                        self.updateNoResultsView()
                    } else {
                        // Display the "No Results" view if the books array is empty
                        self.updateNoResultsView()
                    }
                } else {
                    // Show an alert if there is an error
                    self.showAlert("Oops", errorMessage ?? "Unknown error")
                }
            }
        }
        
    }
    
    //To check if a book is bookmarked or not
    private func isBookBookmarked(_ book: Book) -> Bool {
        let bookmarkedBooks : [Book] = AppDefaults.shared.bookmarkedBooks ?? []
        return bookmarkedBooks.contains { $0.title == book.title }
    }
    
    //To add the bookmarked view in local
    private func addBookmark(_ book: Book) {
        var bookmarkedBooks : [Book] = AppDefaults.shared.bookmarkedBooks ?? []
        bookmarkedBooks.append(book)
        AppDefaults.shared.bookmarkedBooks = bookmarkedBooks
    }
    
    //To remove the book from local
    private func removeBookmark(_ book: Book) {
        var bookmarkedBooks : [Book] = AppDefaults.shared.bookmarkedBooks ?? []
        bookmarkedBooks.removeAll { $0.title == book.title }
        AppDefaults.shared.bookmarkedBooks = bookmarkedBooks
    }
    
    //Function to add done button on the keyboard
    private func addDoneButtonOnKeyboard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        searchBar.inputAccessoryView = toolbar
    }
}


//MARK: SearchBar Delegate
extension HomeViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            books.removeAll()
            bookmarkedTableView.reloadData()
            fetchBooks(query: searchText, offset: 0)
        } else {
            books.removeAll()
            updateNoResultsView()
            bookmarkedTableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text else { return }
        
        if searchText.count >= 3 {
            books.removeAll()
            bookmarkedTableView.reloadData()
            fetchBooks(query: searchText, offset: 0)
        } else {
            books.removeAll()
            updateNoResultsView()
            bookmarkedTableView.reloadData()
        }
    }
}

//MARK: ScrollView Delegate
extension HomeViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Check if scrolling has reached the bottom with a small buffer
        let position = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollHeight = scrollView.frame.size.height
        
        // Trigger when user scrolls to the last 20% of the content height
        if position > (contentHeight - scrollHeight * 1.2) && !isLoading {
            let nextOffset = viewModel.books.count
            if let searchText = searchBar.text, searchText.count > 0 {
                print("Triggering fetch for more books")
                isLoading = true
                fetchBooks(query: searchText, offset: nextOffset)
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

//MARK: TableView Delegate
extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookTableViewCell
        let book = viewModel.books[indexPath.row]
        cell.configure(with: book)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let book = viewModel.books[indexPath.row]
        
        let bookmarkAction = UIContextualAction(style: .normal, title: isBookBookmarked(book) ? "Unbookmark" : "Bookmark") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            
            if self.isBookBookmarked(book) {
                self.removeBookmark(book)
            } else {
                self.addBookmark(book)
            }
            
            completionHandler(true)
        }
        
        bookmarkAction.backgroundColor = isBookBookmarked(book) ? .black : .red
        bookmarkAction.image = UIImage(systemName: isBookBookmarked(book) ? "bookmark.slash.fill" : "bookmark.fill")
        
        let configuration = UISwipeActionsConfiguration(actions: [bookmarkAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

//MARK: @objc functions
extension HomeViewController {
    
    @objc
    private func bookmarkTapped() {
        let vc = BookmarkViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
}
