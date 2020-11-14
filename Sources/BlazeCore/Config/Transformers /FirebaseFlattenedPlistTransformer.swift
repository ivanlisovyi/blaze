//
//  FirebaseFlattenedPlistTransformer.swift
//  
//
//  Created by Lisovyi, Ivan on 14.11.20.
//

import Foundation

struct FirebaseFlattenedPlistTransformer: FirebaseConfigOutputTransformer {
  let keysAndValuesExtractor: FirebaseKeysAndValuesExtractor

  init(keysAndValuesExtractor: FirebaseKeysAndValuesExtractor = FirebaseFlattenedKeysAndValuesExtractor()) {
    self.keysAndValuesExtractor = keysAndValuesExtractor
  }

  func transform(_ data: Data) throws -> Data {
    try PropertyListSerialization.data(
      fromPropertyList: keysAndValuesExtractor.extract(from: data),
      format: .xml,
      options: 0
    )
  }
}
