import Foundation
import NetworkKit

protocol JokeViewModel: UsesNetworkService {
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
    internal let networkService: NetworkService
    internal weak var output: JokeViewOutput!
    
    init() {
        networkService = MixInNetworkService()
    }
    
    func setOutput(output: JokeViewOutput) {
        self.output = output
    }
    
    func loadJoke() {
        networkService.load(resource: Joke.resource()) { joke, error in
            DispatchQueue.main.async(execute: { [weak self] in
                guard let joke = joke else { return }
                self?.output.show(joke: joke.description.htmlDecode())
            })
        }
    }
}
