    import XCTest
    @testable import DeftLog

    final class DeftLogTests: XCTestCase {
        func testDefaultToInfo() {
            // This is an example of a functional test case.
            // Use XCTAssert and related functions to verify your tests produce the correct
            // results.
            let logger = DeftLog.logger(label: "blargh")
            XCTAssertEqual(logger.logLevel, .info)
        }
    }
