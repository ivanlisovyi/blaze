//
//  CredentialsProvider.swift
//  
//
//  Created by Lisovyi, Ivan on 25.08.20.
//

import Foundation

protocol CredentialsProviderProtocol {
  var credentials: Credentials { get }
  
  var rawData: Data { get }
}

struct CredentialsProvider: CredentialsProviderProtocol {
  let credentials: Credentials
  let rawData: Data
  
  init(path: String) throws {
    let data = try Data(contentsOf: URL(fileURLWithPath: path))
    rawData = data
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    credentials = try decoder.decode(Credentials.self, from: data)
  }
}
