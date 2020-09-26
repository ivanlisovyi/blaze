//
//  GoogleAuthNetwork.swift
//  
//
//  Created by Lisovyi, Ivan on 26.09.20.
//

import Foundation
import OAuth2

final class GoogleAuthNetwork: Networking {
  let connection: Connection
  
  init(tokenProvider: TokenProvider) {
    self.connection = Connection(provider: tokenProvider)
  }
  
  func request(url: URL, method: HTTPMethod, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) {
    do {
      try connection.performRequest(method: method.rawValue, urlString: url.absoluteString) { (data, response, error) in
        guard let httpResponse = response as? HTTPURLResponse else {
          completion(.failure(URLError(.unknown)))
          return
        }
        
        if let data = data, 200..<300 ~= httpResponse.statusCode {
          completion(.success((data, httpResponse)))
        } else if let error = error {
          completion(.failure(error))
        } else {
          let code = URLError.Code(rawValue: httpResponse.statusCode)
          completion(.failure(URLError(code)))
        }
      }
    } catch {
      completion(.failure(error))
    }
  }
}
