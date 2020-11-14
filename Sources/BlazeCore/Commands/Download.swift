//
//  Download.swift
//  
//
//  Created by Lisovyi, Ivan on 22.08.20.
//

import Foundation
import ArgumentParser

struct Download: ParsableCommand {
  enum Transform: String, ExpressibleByArgument {
    case none
    case flattening
    case plist
  }
  
  static var configuration = CommandConfiguration(commandName: "download", abstract: "Download Remote Config values from Firebase and dump these values into a json file.")
  
  @Option(name: .shortAndLong, help: "The path to the service-account.json file")
  var credentialsPath: String
  
  @Option(name: .shortAndLong, help: "The path where to save a downloaded file.")
  var outputPath: String
  
  @Flag(help: "Whether the file shall be overwritten if it already exists. Defaults to false.")
  var overwrite: Bool = false
  
  @Option(name: .shortAndLong, help: "The transform used on the downloaded data. Available transforms - none, flattening. Defaults to none.")
  var transform: Transform = .none
  
  func run() throws {
    if FileManager.default.fileExists(atPath: outputPath) && !overwrite {
      return
    }
    
    let downloader = try makeDownloader(withCredentialsAt: credentialsPath)
    let result = try downloader.download()
    
    let transformer = FirebaseConfigOutputTransformerFactory.makeTransformer(for: transform)
    
    let writer = FirebaseSimpleConfigWriter(transformer: transformer)
    try writer.write(result, to: outputPath)
  }
}

private extension Download {
  func makeDownloader(withCredentialsAt path: String) throws -> FirebaseConfigDownloader {
    let credentialsProvider = try FirebaseCredentialsProvider(path: path)
    let tokenProvider = try FirebaseTokenProvider(data: credentialsProvider.rawData)
    
    let network = GoogleAuthNetwork(tokenProvider: tokenProvider)
    let client = FirebaseClient(network: network, credentials: credentialsProvider.credentials)
    
    return FirebaseConfigDownloader(session: client)
  }
}
