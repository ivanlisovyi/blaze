//
//  CredentialsValueExtractor.swift
//  
//
//  Created by Lisovyi, Ivan on 22.08.20.
//

import Foundation

enum CredentialsValueExtractorError: Error {
  case valueNotFound
}

protocol CredentialsValueExtractor {
  associatedtype Value
  
  func extractValue(for key: String) throws -> Value
}

struct CredentialsStringValueExtractor: CredentialsValueExtractor {
  let data: Data
  
  init(data: Data) {
    self.data = data
  }
  
  func extractValue(for key: String) throws -> String {
    let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    guard let value = json?[key] as? String else {
      throw CredentialsValueExtractorError.valueNotFound
    }
    
    return value
  }
}
