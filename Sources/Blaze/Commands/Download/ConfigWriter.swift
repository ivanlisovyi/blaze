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
  func write(_ data: Data, to path: String) throws {
    try data.write(to: URL(fileURLWithPath: path))
  }
}
