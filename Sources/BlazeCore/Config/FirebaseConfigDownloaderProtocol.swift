//
//  ConfigDownloader.swift
//  
//
//  Created by Lisovyi, Ivan on 22.08.20.
//

import Foundation

enum FirebaseConfigDownloaderError: Error {
  case timeout
}

protocol FirebaseConfigDownloaderProtocol {
  func download() throws -> Data
}

struct FirebaseConfigDownloader: FirebaseConfigDownloaderProtocol {
  let session: FirebaseClientProtocol
  
  init(session: FirebaseClientProtocol)  {
    self.session = session
  }
  
  func download() throws -> Data {
    let dispatchGroup = DispatchGroup()
    dispatchGroup.enter()
    
    var receivedResult: Result<Data, Error>!

    session.download(completion: { result in
      receivedResult = result
      dispatchGroup.leave()
    })
    
    if dispatchGroup.wait(timeout: DispatchTime.distantFuture) == .timedOut {
      throw FirebaseConfigDownloaderError.timeout
    }
    
    return try receivedResult.get()
  }
}

