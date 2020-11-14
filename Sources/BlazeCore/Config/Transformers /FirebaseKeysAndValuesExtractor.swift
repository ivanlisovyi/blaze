//
//  FirebaseKeysAndValuesExtractor.swift
//  
//
//  Created by Lisovyi, Ivan on 14.11.20.
//

import Foundation

typealias AnyDictionary = [String: Any]

protocol FirebaseKeysAndValuesExtractor {
  func extract(from firebaseData: Data) throws -> AnyDictionary
}

struct FirebaseFlattenedKeysAndValuesExtractor: FirebaseKeysAndValuesExtractor {
  func extract(from firebaseData: Data) throws -> AnyDictionary {
    guard let json = try JSONSerialization.jsonObject(with: firebaseData, options: .allowFragments) as? AnyDictionary else {
      throw FirebaseConfigOutputTransformerError.dataIsNotValidJSON
    }

    return extractKeysAndValues(from: json)
  }

  private func extractKeysAndValues(from dictionary: AnyDictionary) -> AnyDictionary {
    var result = AnyDictionary()
    dictionary.forEach { key, value in
      if key == "parameters", let parameters = value as? AnyDictionary{
        result.merge(parameters.mapValues(extractDefaultValue))
      } else if let nestedDictionary = value as? [String: Any] {
        result.merge(extractKeysAndValues(from: nestedDictionary))
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
