//
//  FirebaseClientProtocol.swift
//  
//
//  Created by Lisovyi, Ivan on 22.08.20.
//

import Foundation

protocol FirebaseClientProtocol {
  func download(completion: @escaping (Result<Data, Error>) -> Void)
}
