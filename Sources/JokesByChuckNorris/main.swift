import NetworkKit
import Foundation

// https://api.icndb.com/jokes/random

var runLoop: RunLoop = RunLoop.current
var process: MainProcess = MainProcess()

autoreleasepool {
    process.start(arguments: CommandLine.arguments)
    while (!process.shouldExit &&
        (runLoop.run(mode: RunLoop.Mode.default, before: Date.distantFuture))) {
            // do nothing
    }
    exit(process.exitCode)
}
