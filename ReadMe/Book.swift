//
//  Book.swift
//  ReadMe
//
//  Created by Mehmet Deniz Cengiz on 11/1/20.
//  Copyright © 2020 Deniz Cengiz. All rights reserved.
//

import UIKit

struct Book: Hashable {
    let title: String
    let author: String
    var review: String?
    var readMe: Bool
    var image: UIImage?
    static let mockBook = Book(title: "", author: "", readMe: true)
}

extension Book: Codable {
    enum CodingKeys: String, CodingKey {
        case title
        case author
        case review
        case readMe
    }
}
