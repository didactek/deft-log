    import XCTest
    @testable import DeftLog

    final class DeftLogTests: XCTestCase {
        func testDefaultToInfo() {
            let logger = DeftLog.logger(label: "blargh")
            // This is the default for any Logger:
            XCTAssertEqual(logger.logLevel, .info)
        }

        func testSimplePattern() {
            DeftLog.settings = [
                ("blargh.too-specific", .debug),
                ("this-wont-match", .critical),
                ("blar", .trace),
                ("also-wont-match", .critical),
                ("blargh", .debug),  // more complete match, but too late
            ]
            let logger = DeftLog.logger(label: "blargh")
            XCTAssertEqual(logger.logLevel, .trace)
        }
    }
