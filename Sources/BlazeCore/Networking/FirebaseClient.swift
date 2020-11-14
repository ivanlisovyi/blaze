//
//  FirebaseClient.swift
//  
//
//  Created by Lisovyi, Ivan on 22.08.20.
//

import Foundation

import OAuth2

final class FirebaseClient: FirebaseClientProtocol {
  lazy var url = URL(string: "https://firebaseremoteconfig.googleapis.com/v1/projects/\(credentials.projectId)/remoteConfig")!
  
  let networking: Networking
  let credentials: FirebaseCredentials
  
  init(network: Networking, credentials: FirebaseCredentials) {
    self.networking = network
    self.credentials = credentials
  }
  
  func download(completion: @escaping (Result<Data, Error>) -> Void) {
    networking.request(url: url, method: .get) { result in
      completion(result.map(\.0))
    }
  }
}
