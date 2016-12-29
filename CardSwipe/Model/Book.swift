//
//  Book.swift
//  CardSwipe
//
//  Created by Techjini on 28/11/16.
//  Copyright © 2016 Techjini. All rights reserved.
//

import Foundation

import Argo
import Curry
import Runes



struct Items {
    let books: [Book]
}

struct Book {
    let title: String?
    let subtitle: String?
    let decription: String?
    let authors: [String]?
    let thumbnail: URL
}

extension Book: Decodable {
    /**
     Decode an object from JSON.
     
     This is the main entry point for Argo. This function declares how the
     conforming type should be decoded from JSON. Since this is a failable
     operation, we need to return a `Decoded` type from this function.
     
     - parameter json: The `JSON` representation of this object
     
     - returns: A decoded instance of the `DecodedType`
     */

    public static func decode(_ json: JSON) -> Decoded<Book> {
        return curry(Book.init)
            <^> json <|? ["volumeInfo","title"]
            <*> json <|? ["volumeInfo","subtitle"]
            <*> json <|? ["volumeInfo","description"]
            <*> json <||? ["volumeInfo","authors"]
            <*> (json <| ["volumeInfo","imageLinks","thumbnail"] >>- Parser.toURL)
    }
    
 
}



extension Items: Decodable {
    public static func decode(_ json: JSON) -> Decoded<Items> {
      return curry(Items.init)
        <^> json <|| "items"
    }
}


struct Parser {
    
    static func toURL(urlString : String) -> Decoded<URL> {
        guard let url = URL(string: urlString) else {
            return Decoded.failure(DecodeError.custom("Failed to parse String to NSURL"))
        }
        return pure(url)
    }
    
}
