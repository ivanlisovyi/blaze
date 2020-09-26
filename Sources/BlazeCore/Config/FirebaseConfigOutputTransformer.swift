//
//  FirebaseConfigOutputTransformer.swift
//  
//
//  Created by Lisovyi, Ivan on 23.08.20.
//

import Foundation

enum FirebaseConfigOutputTransformerError: Error {
  case dataIsNotValidJSON
}

protocol FirebaseConfigOutputTransformer {
  func transform(_ data: Data) throws -> Data
}

struct FirebaseDefaultValueFlatteningTransformer: FirebaseConfigOutputTransformer {
  typealias AnyDictionary = [String: Any]
  
  func transform(_ data: Data) throws -> Data {
    guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? AnyDictionary else {
      throw FirebaseConfigOutputTransformerError.dataIsNotValidJSON
    }
    
    let result = extractValues(from: json)
    
    return try JSONSerialization.data(withJSONObject: result, options: .sortedKeys)
  }
  
  private func extractValues(from dictionary: AnyDictionary) -> AnyDictionary {
    var result = AnyDictionary()
    dictionary.forEach { key, value in
      if key == "parameters", let parameters = value as? AnyDictionary{
        result.merge(parameters.mapValues(extractDefaultValue))
      } else if let nestedDictionary = value as? [String: Any] {
        result.merge(extractValues(from: nestedDictionary))
      }
    }
    
    return result
  }
  
  private func extractDefaultValue(from nestedDictionary: Any) -> Any? {
    guard let dictionaryValue = nestedDictionary as? AnyDictionary, let defaultValue = dictionaryValue["defaultValue"] as? AnyDictionary else {
      return nil
    }
    
    return defaultValue["value"]
  }
}

private extension Dictionary where Key == String, Value == Any {
  mutating func merge(_ other: Dictionary<Key, Value>) {
    merge(other, uniquingKeysWith: { first, second in first })
  }
}
