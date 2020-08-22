import ArgumentParser

struct Blaze: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A Swift command-line tool to manager Firebase Remote Config",
        subcommands: [Download.self])

    init() { }
}

Blaze.main()
