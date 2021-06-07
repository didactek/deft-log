    import XCTest
    @testable import DeftLog

    final class DeftLogTests: XCTestCase {
        func testDefaultToInfo() {
            let logger = DeftLog.logger(label: "blargh")
            // This is the default for an un-specified Logger:
            XCTAssertEqual(logger.logLevel, .info)
        }

        func testSimplePattern() {
            DeftLog.settings = [
                ("blargh.too-specific", .debug),
                ("this-wont-match", .critical),
                ("blar", .trace),  // <<< This is the one
                ("also-wont-match", .critical),
                ("blargh", .debug),  // More complete match, but too late
            ]
            let logger = DeftLog.logger(label: "blargh")
            XCTAssertEqual(logger.logLevel, .trace)
        }
    }
