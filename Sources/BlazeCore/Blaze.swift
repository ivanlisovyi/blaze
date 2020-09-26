import ArgumentParser

public struct Blaze: ParsableCommand {
  public static let configuration = CommandConfiguration(
    abstract: "A Swift command-line tool to manage Firebase Remote Config.",
    subcommands: [Download.self]
  )
  
  public init() { }
}
