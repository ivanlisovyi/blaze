//
//  Download.swift
//  
//
//  Created by Lisovyi, Ivan on 22.08.20.
//

import Foundation
import ArgumentParser

struct Download: ParsableCommand {
  enum Transformer: String, ExpressibleByArgument {
    case none
    case flattening
  }
  
  static var configuration = CommandConfiguration(commandName: "download", abstract: "Download Remote Config values from Firebase and dump these values intp file.")

  @Option(name: .shortAndLong, help: "The path to service-account.json file")
  var credentialsPath: String
  
  @Option(name: .shortAndLong, help: "The path where to save downloaded file.")
  var outputPath: String
  
  @Flag(help: "Whether the file shall be overwritten if it already exists. Default to false.")
  var overwrite: Bool = false
  
  @Option(name: .shortAndLong, help: "The transform used on the downloaded data. Availables transforms - none, flattening. Defaults to none.")
  var transform: Transformer = .none
  
  func run() throws {
    if FileManager.default.fileExists(atPath: outputPath) && !overwrite {
      return
    }
    
    let credentialsProvider = try CredentialsProvider(path: credentialsPath)
    let tokenProvider = try SessionTokenProvider(data: credentialsProvider.rawData)
    let session = Session(tokenProvider: tokenProvider, credentials: credentialsProvider.credentials)
    
    let downloader = RemoteConfigDownloader(session: session)
    let result = try downloader.download()
    
    let transformer = ConfigOutputTransformerFactory.makeTransformer(for: transform)
 
    let writer = SimpleConfigWriter(transformer: transformer)
    try writer.write(result, to: outputPath)
  }
}
