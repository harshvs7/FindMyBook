//
//  Model.swift
//  FindMyBook
//
//  Created by Harshvardhan Sharma on 07/11/24.
//

import Foundation

struct BookResponse: Codable {
    let numFound, start: Int?
    let numFoundExact: Bool?
    let docs: [Doc]?
    let bookResponseNumFound: Int?
    let q: String?
    let offset: Int?

    enum CodingKeys: String, CodingKey {
        case numFound, start, numFoundExact, docs
        case bookResponseNumFound = "num_found"
        case q, offset
    }
}

// MARK: - Doc
struct Doc: Codable {
    let authorAlternativeName, authorKey, authorName, contributor: [String]?
    let coverEditionKey: String?
    let coverI: Int?
    let ddc: [String]?
    let ebookAccess: String?
    let ebookCountI, editionCount: Int?
    let editionKey: [String]?
    let firstPublishYear: Int?
    let firstSentence, format: [String]?
    let hasFulltext: Bool?
    let ia, iaCollection: [String]?
    let iaCollectionS: String?
    let isbn: [String]?
    let key: String?
    let language: [String]?
    let lastModifiedI: Int?
    let lcc, lccn: [String]?
    let lendingEditionS, lendingIdentifierS: String?
    let numberOfPagesMedian: Int?
    let oclc: [String]?
    let ospCount: Int?
    let printdisabledS: String?
    let publicScanB: Bool?
    let publishDate, publishPlace: [String]?
    let publishYear: [Int]?
    let publisher, seed: [String]?
    let title, titleSort, titleSuggest: String?
    let type: String?
    let idGoodreads, idLibrarything, idAmazon, idBetterWorldBooks: [String]?
    let idOverdrive, subject, place, iaLoadedID: [String]?
    let iaBoxID: [String]?
    let ratingsAverage, ratingsSortable: Double?
    let ratingsCount, ratingsCount1, ratingsCount2, ratingsCount3: Int?
    let ratingsCount4, ratingsCount5, readinglogCount, wantToReadCount: Int?
    let currentlyReadingCount, alreadyReadCount: Int?
    let publisherFacet, placeKey, subjectFacet: [String]?
    let version: Double?
    let placeFacet: [String]?
    let lccSort: String?
    let authorFacet, subjectKey: [String]?
    let ddcSort, subtitle: String?
    let idDoi, person, personKey, personFacet: [String]?
    let time, timeFacet, timeKey: [String]?

    enum CodingKeys: String, CodingKey {
        case authorAlternativeName = "author_alternative_name"
        case authorKey = "author_key"
        case authorName = "author_name"
        case contributor
        case coverEditionKey = "cover_edition_key"
        case coverI = "cover_i"
        case ddc
        case ebookAccess = "ebook_access"
        case ebookCountI = "ebook_count_i"
        case editionCount = "edition_count"
        case editionKey = "edition_key"
        case firstPublishYear = "first_publish_year"
        case firstSentence = "first_sentence"
        case format
        case hasFulltext = "has_fulltext"
        case ia
        case iaCollection = "ia_collection"
        case iaCollectionS = "ia_collection_s"
        case isbn, key, language
        case lastModifiedI = "last_modified_i"
        case lcc, lccn
        case lendingEditionS = "lending_edition_s"
        case lendingIdentifierS = "lending_identifier_s"
        case numberOfPagesMedian = "number_of_pages_median"
        case oclc
        case ospCount = "osp_count"
        case printdisabledS = "printdisabled_s"
        case publicScanB = "public_scan_b"
        case publishDate = "publish_date"
        case publishPlace = "publish_place"
        case publishYear = "publish_year"
        case publisher, seed, title
        case titleSort = "title_sort"
        case titleSuggest = "title_suggest"
        case type
        case idGoodreads = "id_goodreads"
        case idLibrarything = "id_librarything"
        case idAmazon = "id_amazon"
        case idBetterWorldBooks = "id_better_world_books"
        case idOverdrive = "id_overdrive"
        case subject, place
        case iaLoadedID = "ia_loaded_id"
        case iaBoxID = "ia_box_id"
        case ratingsAverage = "ratings_average"
        case ratingsSortable = "ratings_sortable"
        case ratingsCount = "ratings_count"
        case ratingsCount1 = "ratings_count_1"
        case ratingsCount2 = "ratings_count_2"
        case ratingsCount3 = "ratings_count_3"
        case ratingsCount4 = "ratings_count_4"
        case ratingsCount5 = "ratings_count_5"
        case readinglogCount = "readinglog_count"
        case wantToReadCount = "want_to_read_count"
        case currentlyReadingCount = "currently_reading_count"
        case alreadyReadCount = "already_read_count"
        case publisherFacet = "publisher_facet"
        case placeKey = "place_key"
        case subjectFacet = "subject_facet"
        case version = "_version_"
        case placeFacet = "place_facet"
        case lccSort = "lcc_sort"
        case authorFacet = "author_facet"
        case subjectKey = "subject_key"
        case ddcSort = "ddc_sort"
        case subtitle
        case idDoi = "id_doi"
        case person
        case personKey = "person_key"
        case personFacet = "person_facet"
        case time
        case timeFacet = "time_facet"
        case timeKey = "time_key"
    }
}

enum TypeEnum: String, Codable {
    case work = "work"
}

struct Book: Codable {
    let title: String
    let author: String
    let coverID: Int?
    let ratingsAverage: Double
    let ratingsCount: Int
    let genre: [String]
    let publicationYear: Int
    let description: String
}

