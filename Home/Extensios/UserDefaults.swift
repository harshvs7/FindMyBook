//
//  UserDefaults.swift
//  FindMyBook
//
//  Created by Harshvardhan Sharma on 07/11/24.
//

import Foundation

struct DefaultValues {
    static let bookmarkedBooks = "bookmarkedBooks"
}

//A  class to access the userDefaults with modularity and at one place
class AppDefaults {
    static let shared = AppDefaults()
    private var userDefaults = UserDefaults.standard
    
    var bookmarkedBooks: [Book]? {
        get {
            guard let savedData = userDefaults.data(forKey: DefaultValues.bookmarkedBooks) else {
                return []
            }
            
            do {
                let decoder = JSONDecoder()
                let books = try decoder.decode([Book].self, from: savedData)
                return books
            } catch {
                print("Error decoding bookmarked books: \(error)")
                return []
            }
        }
        set {
            if let newBooks = newValue {
                do {
                    let encoder = JSONEncoder()
                    let encodedData = try encoder.encode(newBooks)
                    userDefaults.setValue(encodedData, forKey: DefaultValues.bookmarkedBooks)
                } catch {
                    print("Error encoding bookmarked books: \(error)")
                }
            } else {
                userDefaults.removeObject(forKey: DefaultValues.bookmarkedBooks)
            }
        }
    }
    
}

