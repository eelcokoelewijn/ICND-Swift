import NetworkKit
import Foundation

// https://api.icndb.com/jokes/random

let waitSignal = DispatchSemaphore(value: 0)

let icndbService = MixInICNDBService()
icndbService.getRandomJoke { joke in
    defer {
        waitSignal.signal()
    }
    print(joke)
}

let waitTimeout = waitSignal.wait(timeout: DispatchTime.distantFuture)

