//
//  Download.swift
//  
//
//  Created by Lisovyi, Ivan on 22.08.20.
//

import Foundation
import ArgumentParser

struct Download: ParsableCommand {
  static var configuration = CommandConfiguration(commandName: "download", abstract: "Download Remote Config values from Firebase and dump these values intp file")

  @Option(name: .shortAndLong, help: "The path to service-account.json file")
  var credentialsPath: String
  
  @Option(name: .shortAndLong, help: "The path where to save downloaded file.")
  var outputPath: String
  
  @Flag(help: "Whether the file shall be overwritten if it already exists. Default to false")
  var overwrite: Bool = false
  
  func run() throws {
    let downloader = FirebaseConfigDownloader(credentialsPath: credentialsPath)
    let result = try downloader.download()
    
    print(result, outputPath, overwrite)
  }
}
