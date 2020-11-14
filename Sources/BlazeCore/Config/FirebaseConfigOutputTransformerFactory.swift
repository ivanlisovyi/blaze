//
//  FirebaseConfigOutputTransformerFactory.swift
//  
//
//  Created by Lisovyi, Ivan on 23.08.20.
//

import Foundation

struct FirebaseConfigOutputTransformerFactory {
  static func makeTransformer(for option: Download.Transform) -> FirebaseConfigOutputTransformer? {
    switch option {
    case .flattening:
      return FirebaseFlattenedJsonTransformer()
    case .plist:
      return FirebaseFlattenedPlistTransformer()
    default:
      return nil
    }
  }
}
