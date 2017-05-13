import Foundation
import NetworkKit
import App

protocol JokeViewModel: UsesICNDBService {
    func setOutput(output: JokeViewOutput)
    func loadJoke()
}

protocol UsesJokeViewModel {
    var jokeViewModel: JokeViewModel { get }
}

protocol JokeViewOutput: class {
    func show(joke: String)
}

protocol UsesJokeViewOutput {
    var output: JokeViewOutput! { get }
}

class MixInJokeViewModel: JokeViewModel, UsesJokeViewOutput {
    internal let icndbService: ICNDBService
    internal weak var output: JokeViewOutput!

    init() {
        icndbService = MixInICNDBService()
    }

    func setOutput(output: JokeViewOutput) {
        self.output = output
    }

    func loadJoke() {
        icndbService.getRandomJoke(substituteFirstname: nil, substituteLastname: nil) { joke in
            DispatchQueue.main.async(execute: { [weak self] in
                self?.output.show(joke: joke)
            })
        }
    }
}
