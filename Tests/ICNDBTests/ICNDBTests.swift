import XCTest
@testable import ICNDBCore

final class ICNDBTests: XCTestCase {
    func testICNDBURL() {
        XCTAssertEqual(MixInICNDBService().networkService.baseURL.absoluteString, "http://api.icndb.com/")
    }

    static var allTests = [
        ("testICNDBURL", testICNDBURL),
    ]
}
