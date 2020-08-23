//
//  ConfigOutputTransformer.swift
//  
//
//  Created by Lisovyi, Ivan on 23.08.20.
//

import Foundation

enum ConfigOutputTransformerError: Error {
  case dataIsNotValidJSON
}

protocol ConfigOutputTransformer {
  func transform(_ data: Data) throws -> Data
}

struct DefaultValueFlatteningTransformer: ConfigOutputTransformer {
  typealias AnyDictionary = [String: Any]
  
  func transform(_ data: Data) throws -> Data {
    guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? AnyDictionary else {
      throw ConfigOutputTransformerError.dataIsNotValidJSON
    }
    
    let result = extractValues(from: json)

    return try JSONSerialization.data(withJSONObject: result, options: .sortedKeys)
  }
  
  func extractValues(from dictionary: AnyDictionary) -> AnyDictionary {
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
  
  func extractDefaultValue(from nestedDictionary: Any) -> Any? {
    guard let dictionaryValue = nestedDictionary as? AnyDictionary, let defaultValue = dictionaryValue["defaultValue"] as? AnyDictionary else {
      return nil
    }
    
    return defaultValue["value"]
  }
}

extension Dictionary where Key == String, Value == Any {
  mutating func merge(_ other: Dictionary<Key, Value>) {
    merge(other, uniquingKeysWith: { first, second in first })
  }
}
