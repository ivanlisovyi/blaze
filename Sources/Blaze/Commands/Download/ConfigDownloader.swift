//
//  ConfigDownloader.swift
//  
//
//  Created by Lisovyi, Ivan on 22.08.20.
//

import Foundation

enum ConfigDownloaderError: Error {
  case timeout
}

protocol ConfigDownloader {
  func download() throws -> Data
}

struct RemoteConfigDownloader: ConfigDownloader {
  let session: SessionProtocol
  
  init(session: SessionProtocol)  {
    self.session = session
  }
  
  func download() throws -> Data {
    let dispatchGroup = DispatchGroup()
    dispatchGroup.enter()
    
    var receivedResult: Result<Data, Error>!

    try session.download(completion: { result in
      receivedResult = result
      dispatchGroup.leave()
    })
    
    if dispatchGroup.wait(timeout: DispatchTime.distantFuture) == .timedOut {
      throw ConfigDownloaderError.timeout
    }
    
    return try receivedResult.get()
  }
}

