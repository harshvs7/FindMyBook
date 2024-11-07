//
//  viewModel.swift
//  FindMyBook
//
//  Created by Harshvardhan Sharma on 07/11/24.
//

import Foundation
import UIKit

class HomeViewModel {
    
    var books : [Book] = []

    var isLoading = false
    var totalResults = 0
    
    func fetchBookCoverImage(coverID: Int?, completion: @escaping (UIImage?) -> Void) {
        guard let coverID = coverID else {
            completion(UIImage(systemName: "book"))
            return
        }
        
        let coverURL = "https://covers.openlibrary.org/b/id/\(coverID)-M.jpg"
        guard let url = URL(string: coverURL) else {
            completion(UIImage(systemName: "book"))
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(UIImage(systemName: "book"))
                }
            }
        }
    }
    
    func fetchBooks(query: String, offset: Int, completion: @escaping (Bool, String?) -> Void) {
        // Prevent multiple API calls if already loading
        guard !isLoading else { return }
        isLoading = true
        
        // Prepare the URL for the API request
        let urlString = "https://openlibrary.org/search.json?title=\(query)&limit=10&offset=\(offset)"
        guard let url = URL(string: urlString) else {
            completion(false, "Invalid URL")
            return
        }
        
        // Perform the data task
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                self.isLoading = false
                DispatchQueue.main.async {
                    completion(false, "Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                }
                return
            }
            
            do {
                // Decode the JSON data into the BookSearchResponse structure
                let bookResponse = try JSONDecoder().decode(BookResponse.self, from: data)
                self.totalResults = bookResponse.numFound ?? 0
                
                // Map the book documents to Book objects
                let newBooks = bookResponse.docs?.compactMap { bookDoc -> Book? in
                    return Book(
                        title: bookDoc.title ?? "" ,
                        author: bookDoc.authorName?.first ?? "Unknown",
                        coverID: bookDoc.coverI,
                        ratingsAverage: bookDoc.ratingsAverage ?? 0.0,
                        ratingsCount: bookDoc.ratingsCount ?? 0,
                        genre: bookDoc.publisher ?? ["Unknown"],
                        publicationYear: bookDoc.firstPublishYear ?? 0,
                        description: bookDoc.publishDate?.first ?? "No description available"
                    )
                }
                
                DispatchQueue.main.async {
                    if let newBooks = newBooks {
                        if offset == 0 {
                            self.books = newBooks
                        } else {
                            self.books.append(contentsOf: newBooks)
                        }
                    }
                    self.isLoading = false
                    completion(true, nil)
                }
            } catch {
                print("Error decoding response: \(error)")
                self.isLoading = false
                DispatchQueue.main.async {
                    completion(false, "Error decoding response: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}

