//
//  Book.swift
//  ReadMe
//
//  Created by Mehmet Deniz Cengiz on 11/1/20.
//  Copyright © 2020 Deniz Cengiz. All rights reserved.
//

import UIKit

struct Book {
    let title: String
    let author: String
    var review: String?
    
    var image: UIImage {
        Library.loadImage(forBook: self) ?? LibrarySymbol.letterSquare(letter: title.first).image
    }
}
