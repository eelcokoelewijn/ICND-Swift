import XCTest
@testable import ChuckNorrisCore

final class JokesByChuckNorrisTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.

        XCTAssertEqual(MixInICNDBService().networkService.baseURL.absoluteString, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
