//
//  SessionTokenProvider.swift
//  
//
//  Created by Lisovyi, Ivan on 25.08.20.
//

import Foundation

import OAuth2

enum SessionTokenProviderError: Error {
  case invalidCredentialsData
}

final class SessionTokenProvider: TokenProvider {
  static let defaultScopes = ["https://www.googleapis.com/auth/firebase.remoteconfig"]
  
  let `internal`: TokenProvider
  
  init(data: Data, scopes: [String] = defaultScopes) throws {
    guard let provider = ServiceAccountTokenProvider(credentialsData: data, scopes: scopes) else {
      throw SessionTokenProviderError.invalidCredentialsData
    }
    
    `internal` = provider
  }
  
  func withToken(_ callback: @escaping (Token?, Error?) -> Void) throws {
    try `internal`.withToken(callback)
  }
}

