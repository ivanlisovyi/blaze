//
//  Session.swift
//  
//
//  Created by Lisovyi, Ivan on 22.08.20.
//

import Foundation

import OAuth2

final class Session: SessionProtocol {
  var url: String {
    "https://firebaseremoteconfig.googleapis.com/v1/projects/\(credentials.projectId)/remoteConfig"
  }
  
  let tokenProvider: TokenProvider
  let credentials: Credentials
  
  init(tokenProvider: TokenProvider, credentials: Credentials) {
    self.tokenProvider = tokenProvider
    self.credentials = credentials
  }
  
  func download(completion: @escaping (Result<Data, Error>) -> Void) throws {
    let connection = Connection(provider: tokenProvider)
    try connection.performRequest(method: "GET", urlString: url) { (data, response, error) in
      
      if let data = data {
        completion(.success(data))
      } else {
        completion(.failure(error ?? URLError(.unknown)))
      }
    }
  }
}
