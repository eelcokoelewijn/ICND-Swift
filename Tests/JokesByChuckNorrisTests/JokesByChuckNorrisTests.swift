import XCTest
@testable import JokesByChuckNorris

final class JokesByChuckNorrisTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(JokesByChuckNorris().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
