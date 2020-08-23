//
//  SessionProtocol.swift
//  
//
//  Created by Lisovyi, Ivan on 22.08.20.
//

import Foundation

protocol SessionProtocol {
  func download(completion: @escaping (Result<Data, Error>) -> Void) throws
}
