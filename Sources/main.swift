import NetworkKit
import Foundation

// https://api.icndb.com/jokes/random

let waitSignal = DispatchSemaphore(value: 0)
let networker = NetworkKit()

networker.load(resource: Joke.resource()) { joke, error in
    defer {
        waitSignal.signal()
    }
    
    guard let joke = joke else {
        print(error)
        return
    }
    print(joke.description.htmlDecode())
}

let waitTimeout = waitSignal.wait(timeout: DispatchTime.distantFuture)

