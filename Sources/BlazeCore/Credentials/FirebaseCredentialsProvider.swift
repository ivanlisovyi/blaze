//
//  FirebaseCredentialsProvider.swift
//  
//
//  Created by Lisovyi, Ivan on 25.08.20.
//

import Foundation

protocol FirebaseCredentialProviding {
  var credentials: FirebaseCredentials { get }
  
  var rawData: Data { get }
}

struct FirebaseCredentialsProvider: FirebaseCredentialProviding {
  let credentials: FirebaseCredentials
  let rawData: Data
  
  init(path: String) throws {
    let data = try Data(contentsOf: URL(fileURLWithPath: path))
    rawData = data
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    credentials = try decoder.decode(FirebaseCredentials.self, from: data)
  }
}
