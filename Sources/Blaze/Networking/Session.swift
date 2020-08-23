//
//  Session.swift
//  
//
//  Created by Lisovyi, Ivan on 22.08.20.
//

import Foundation

import OAuth2

final class Session: SessionProtocol {
  let tokenProvider: TokenProvider
  let url: String
  
  init(tokenProvider: TokenProvider, url: String) {
    self.tokenProvider = tokenProvider
    self.url = url
  }
  
  func download(completion: @escaping (Result<Data, Error>) -> Void) throws {
    let connection = Connection(provider: self.tokenProvider)
    try connection.performRequest(method: "GET", urlString: self.url) { (data, response, error) in
      
      if let data = data {
        completion(.success(data))
      } else {
        completion(.failure(error ?? URLError(.unknown)))
      }
    }
  }
}
