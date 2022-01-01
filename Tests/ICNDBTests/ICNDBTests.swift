import XCTest
@testable import ICNDBCore

final class ICNDBTests: XCTestCase {
    func testICNDBURL() {
        XCTAssertEqual(MixInICNDBService().networkService.baseURL.absoluteString, "https://api.icndb.com/")
    }

    static var allTests = [
        ("testICNDBURL", testICNDBURL),
    ]
}
