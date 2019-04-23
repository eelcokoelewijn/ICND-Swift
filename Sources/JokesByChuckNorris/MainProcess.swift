//
//  File.swift
//  ChuckNorrisCore
//
//  Created by Eelco Koelewijn on 24/04/2019.
//

import Foundation
import ChuckNorrisCore

enum ChuckCommand: String {
    case help
    case random
    case nameSubstitued
    case categories
}

class MainProcess {
    private var arguments: [String] = []
    private let icndbService: MixInICNDBService = MixInICNDBService()
    var shouldExit: Bool = false
    var exitCode: Int32 = 0

    func start(arguments: [String]) {
        self.arguments = arguments
        guard arguments.count > 1, let command = ChuckCommand(rawValue: arguments[1]) else {
            shouldExit = true
            exitCode = 1
            return
        }
        switch command {
        case .random:
            icndbService.getRandomJoke { [weak self] joke in
                print("\(joke)")
                self?.commandCompleted(withExitCode: 0)
            }
        case .categories:
            icndbService.getJokeCategories { [weak self] categories in
                categories.forEach {
                    print("\($0)")
                }
                self?.commandCompleted(withExitCode: 0)
            }
        case .nameSubstitued:
            guard arguments.count > 3 else {
                shouldExit = true
                commandCompleted(withExitCode: 2)
                return
            }
            let firstName = arguments[2]
            let lastname = arguments[3]
            icndbService.getRandomJoke(substituteFirstname: firstName,
                                       substituteLastname: lastname) { [weak self] in
                                        print("\($0)")
                                        self?.commandCompleted(withExitCode: 0)
            }
        case .help:
            fallthrough
        @unknown default:
            print("""
                - random: one random chuck norris joke
                - categories: list all chuck norris categories
                - nameSubstitued: one random joke, takes two arguments firstname and lastname.
                                  jokes nameSubstitued Hank Long
                - help: shows this help message
                """)
            commandCompleted(withExitCode: 0)
        }
    }

    private func commandCompleted(withExitCode code: Int32) {
        if Thread.isMainThread {
            shouldExit = true
            exitCode = code
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.shouldExit = true
            self?.exitCode = 0
        }
    }
}
