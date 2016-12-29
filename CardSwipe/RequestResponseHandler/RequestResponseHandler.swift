//
//  RequestResponseHandler.swift
//  CardSwipe
//
//  Created by Techjini on 28/11/16.
//  Copyright © 2016 Techjini. All rights reserved.
//

import Foundation
import Argo

let bookApi = "https://www.googleapis.com/books/v1/volumes?q=quilting"

typealias BookResponseError = (_ books: [Book]?, _ error: Error?) -> Void

struct RequestResponseHandler {
    
    func getCardRequest(onCompletion: BookResponseError?) {
        let request = URLRequest(url: URL(string: bookApi)!)
        let coreService = CoreService(request: request)
        coreService.makeRequest { (data: Data?, error: Error?) in
            
            guard let responseError = error else {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    let item: Decoded<Items> =  decode(json)
                    let books = item.value?.books
                    //To update UI
                    DispatchQueue.main.async {
                        onCompletion?(books,nil)
                    }
                    
                } catch let error as NSError {
                    print("\(error)")
                }
                return
            }
            onCompletion?(nil,responseError)
        }
    }
    
}


