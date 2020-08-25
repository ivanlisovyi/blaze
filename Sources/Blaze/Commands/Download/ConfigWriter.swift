//
//  ConfigWriter.swift
//  
//
//  Created by Lisovyi, Ivan on 23.08.20.
//

import Foundation

protocol ConfigWriter {
  func write(_ data: Data, to path: String) throws
}

struct SimpleConfigWriter: ConfigWriter {
  let transformer: ConfigOutputTransformer?
  
  init(transformer: ConfigOutputTransformer? = nil) {
    self.transformer = transformer
  }
  
  func write(_ data: Data, to path: String) throws {
    var output = data
    if let transformer = transformer {
      output = try transformer.transform(data)
    }
    
    try output.write(to: URL(fileURLWithPath: path))
  }
}
