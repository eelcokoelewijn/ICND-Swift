import NetworkKit
import Foundation
import ArgumentParser
import ICNDBCore

// https://api.icndb.com/jokes/random

extension ICNDB {
    struct Random: AsyncParsableCommand {
        static var configuration = CommandConfiguration(abstract: "Random Chuck Norris joke(s).")

        @Option(name: .shortAndLong, help: "Number of jokes.")
        var number: Int = 1
        @Option(name: .shortAndLong, help: "Substitute first-name for Chuck.")
        var firstName: String?
        @Option(name: .shortAndLong, help: "Substitute last-name for Norris.")
        var lastName: String?

        mutating func run() async throws {
            let icndbService: MixInICNDBService = MixInICNDBService()
            let jokes = try await icndbService.getRandomJoke(substituteFirstname: firstName, substituteLastname: lastName, numberOfJokes: number)
            jokes.forEach {
                print("\($0)")
            }
        }
    }

    struct Categories: AsyncParsableCommand {
        static var configuration = CommandConfiguration(abstract: "ICNDB categories")

        mutating func run() async throws {
            let icndbService: MixInICNDBService = MixInICNDBService()
            let categories = try await icndbService.getJokeCategories()
            categories.forEach {
                print("\($0)")
            }
        }
    }

    struct Person: ParsableArguments {}
}

@main
struct ICNDB: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Internet Chuck Norris Database",
        subcommands: [Random.self, Categories.self],
        defaultSubcommand: Random.self)
}
