//
//  Networking.swift
//  
//
//  Created by Lisovyi, Ivan on 26.09.20.
//

import Foundation

enum HTTPMethod: String, Equatable {
  case get = "GET"
  case post = "POST"
}

protocol Networking {
  func request(url: URL, method: HTTPMethod, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void)
}
