@testable import ICNDBCore
import XCTest

final class ICNDBTests: XCTestCase {
    func testICNDBURL() {
        XCTAssertEqual(MixInICNDBService().networkService.baseURL.absoluteString, "http://api.icndb.com/")
    }

    func testHtmlDecode() {
        let subject = "This &amp; that!"
        let result = subject.htmlDecode()
        XCTAssertEqual(result, "This & that!", "Html encode &amp; to & in \(result)")
    }

    static var allTests = [
        (
            "testICNDBURL", testICNDBURL,
            "testHtmlDecode", testHtmlDecode
        )
    ]
}
