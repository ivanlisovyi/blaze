//
//  FirebaseFlattenedJsonTransformer.swift
//  
//
//  Created by Lisovyi, Ivan on 14.11.20.
//

import Foundation

struct FirebaseFlattenedJsonTransformer: FirebaseConfigOutputTransformer {
  let keysAndValuesExtractor: FirebaseKeysAndValuesExtractor

  init(keysAndValuesExtractor: FirebaseKeysAndValuesExtractor = FirebaseFlattenedKeysAndValuesExtractor()) {
    self.keysAndValuesExtractor = keysAndValuesExtractor
  }

  func transform(_ data: Data) throws -> Data {
    try JSONSerialization.data(
      withJSONObject: keysAndValuesExtractor.extract(from: data),
      options: .sortedKeys
    )
  }
}
