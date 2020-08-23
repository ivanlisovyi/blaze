//
//  ConfigOutputTransformerFactory.swift
//  
//
//  Created by Lisovyi, Ivan on 23.08.20.
//

import Foundation

struct ConfigOutputTransformerFactory {
  static func makeTransformer(for option: Download.Transformer) -> ConfigOutputTransformer? {
    switch option {
    case .flattening:
      return DefaultValueFlatteningTransformer()
    default:
      return nil
    }
  }
}
