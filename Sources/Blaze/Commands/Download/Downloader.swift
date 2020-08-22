//
//  Downloader.swift
//  
//
//  Created by Lisovyi, Ivan on 22.08.20.
//

import Foundation
import Combine

import OAuth2

enum ConfigDownloaderError: Error {
  case invalidURL
  case invalidCredentials
  case projectIdMissing
  case fetchFailed
  case timeout
}

protocol ConfigDownloader {
  func download() throws -> Any
}

final class FirebaseConfigDownloader: ConfigDownloader {
  private var cancellables = Set<AnyCancellable>()
  
  let credentialsPath: String
  
  private var scopes: [String] {
    ["https://www.googleapis.com/auth/firebase.remoteconfig"]
  }

  init(credentialsPath path: String)  {
    credentialsPath = path
  }
  
  func download() throws -> Any {
    let dispatchGroup = DispatchGroup()
    dispatchGroup.enter()
    
    var result: Result<Any, Error>!
    
    Just(try Data(contentsOf: URL(fileURLWithPath: credentialsPath)))
      .setFailureType(to: Error.self)
      .flatMap {
        Publishers.Zip(
          self.extractProjectId(data: $0).map(self.makeDownloadURL),
          Just($0).setFailureType(to: Error.self)
        )
      }
      .flatMap(request)
      .retry(3)
      .eraseToAnyPublisher()
      .print()
      .sink(receiveCompletion: { completion in
        if case let .failure(error) = completion {
          result = .failure(error)
          
          dispatchGroup.leave()
        }
      }, receiveValue: { value in
        result = .success(value)
        dispatchGroup.leave()
      })
      .store(in: &cancellables)
    
    if dispatchGroup.wait(timeout: DispatchTime.distantFuture) == .timedOut {
      throw ConfigDownloaderError.timeout
    }
    
    return try result.get()
  }
  
  private func extractProjectId(data: Data) -> AnyPublisher<String, Error> {
    Future<String, Error> { promise in
      let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
      if let projectId = json?["project_id"] as? String {
        promise(.success(projectId))
      } else {
        promise(.failure(ConfigDownloaderError.projectIdMissing))
      }
    }.eraseToAnyPublisher()
  }
  
  private func makeDownloadURL(with projectId: String) -> String {
    "https://firebaseremoteconfig.googleapis.com/v1/projects/\(projectId)/remoteConfig"
  }
  
  private func request(url: String, credentialsData: Data) -> AnyPublisher<Data, Error> {
    guard let tokenProvider = ServiceAccountTokenProvider(credentialsData: credentialsData, scopes: scopes) else {
      return Fail(error: ConfigDownloaderError.invalidCredentials).eraseToAnyPublisher()
    }
    
    let connection = Connection(provider: tokenProvider)
    
    return Future<Data, Error> { promise in
      do {
        try connection.performRequest(method: "GET", urlString: url) { (data, response, error) in
          if let data = data {
            promise(.success(data))
          } else {
            promise(.failure(error ?? ConfigDownloaderError.fetchFailed))
          }
        }
      } catch {
        promise(.failure(error))
      }
    }.eraseToAnyPublisher()
  }
}

