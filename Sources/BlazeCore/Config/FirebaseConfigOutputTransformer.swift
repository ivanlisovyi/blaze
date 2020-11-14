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
