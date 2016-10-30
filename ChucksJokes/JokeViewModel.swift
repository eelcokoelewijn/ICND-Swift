import Foundation
import NetworkKit

protocol JokeViewModel {
    func setOutput(output: JokeViewOutput)
    func loadJoke()
}

protocol JokeViewOutput: class {
    func show(joke: String)
}

class JokeViewModelImplementation: JokeViewModel {
    private let networker = NetworkKit()
    private weak var output: JokeViewOutput!
    
    func setOutput(output: JokeViewOutput) {
        self.output = output
    }
    
    func loadJoke() {
        networker.load(resource: Joke.resource()) { joke, error in
            DispatchQueue.main.async(execute: { [weak self] in
                guard let joke = joke else { return }
                self?.output.show(joke: joke.description.htmlDecode())
            })
        }
    }
}
