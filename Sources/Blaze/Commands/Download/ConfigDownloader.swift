//
//  ConfigDownloader.swift
//  
//
//  Created by Lisovyi, Ivan on 22.08.20.
//

import Foundation
import Combine

import OAuth2

enum ConfigDownloaderError: Error {
  case invalidCredentials
  case timeout
}

protocol ConfigDownloader {
  func download() throws -> Data
}

final class RemoteConfigDownloader: ConfigDownloader {
  private var cancellables = Set<AnyCancellable>()
  
  let credentialsPath: String
  
  init(credentialsPath: String)  {
    self.credentialsPath = credentialsPath
  }
  
  func download() throws -> Data {
    let data = try Data(contentsOf: URL(fileURLWithPath: credentialsPath))
    let url = try prepareURL(data: data)
    
    return try download(from: url, credentialsData: data)
  }
  
  private func prepareURL(data: Data) throws -> String {
    let extractor = CredentialsStringValueExtractor(data: data)
    let projectId = try extractor.extractValue(for: "project_id")
    return makeDownloadURL(with: projectId)
  }
  
  private func download(from url: String, credentialsData: Data) throws -> Data {
    guard let tokenProvider = ServiceAccountTokenProvider(credentialsData: credentialsData, scopes: makeScopes()) else {
      throw ConfigDownloaderError.invalidCredentials
    }
    
    let dispatchGroup = DispatchGroup()
    dispatchGroup.enter()
    
    var receivedResult: Result<Data, Error>!

    try Session(tokenProvider: tokenProvider, url: url).download(completion: { result in
      receivedResult = result
      dispatchGroup.leave()
    })
    
    if dispatchGroup.wait(timeout: DispatchTime.distantFuture) == .timedOut {
      throw ConfigDownloaderError.timeout
    }
    
    return try receivedResult.get()
  }
  
  private func makeDownloadURL(with projectId: String) -> String {
    "https://firebaseremoteconfig.googleapis.com/v1/projects/\(projectId)/remoteConfig"
  }
  
  private func makeScopes() -> [String] {
    ["https://www.googleapis.com/auth/firebase.remoteconfig"]
  }
}

