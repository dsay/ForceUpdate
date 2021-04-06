import XCTest
@testable import ForceUpdate

final class ForceUpdateTests: XCTestCase {
    
    func testCreate() {
        let version: Version = "1.0.2"

        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 0)
        XCTAssertEqual(version.patch, 2)
        XCTAssertEqual(version.string, "1.0.2")
    }
    
    func testShorterVersion() {
        let version: Version = "1.2"

        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 2)
        XCTAssertEqual(version.patch, 0)
        XCTAssertEqual(version.string, "1.2.0")
    }
    
    func testLongerVersion() {
        let version: Version = "1.2.4.5"

        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 2)
        XCTAssertEqual(version.patch, 4)
        XCTAssertEqual(version.string, "1.2.4")
    }
    
    func testExpressionEquality() {
        let version: Version = "1.2.4"

        XCTAssertTrue(version == Version("1.2.4"))
        XCTAssertFalse(version == Version("1.2.2"))
        XCTAssertFalse(version ==  Version("1.1.4"))
        XCTAssertFalse(version == Version("0.2.4"))
        XCTAssertTrue(version == Version("1.2.4.5"))
        XCTAssertFalse(version == Version("1.2"))
    }
    
    func testExpressionless() {
        let version: Version = "1.2.4"
        
        XCTAssertTrue(version < Version("1.2.2"))
        XCTAssertTrue(version < Version("1.1.4"))
        XCTAssertFalse(version < Version("1.2.4"))
        XCTAssertTrue(version < Version("0.2.4"))
        XCTAssertFalse(version < Version("1.2.4.5"))
        XCTAssertTrue(version < Version("1.2"))
    }
    
    func testExpressionMore() {
        let version: Version = "1.2.4"
        
        XCTAssertFalse(version > Version("1.2.2"))
        XCTAssertFalse(version > Version("1.1.4"))
        XCTAssertFalse(version > Version("1.2.4"))
        XCTAssertFalse(version > Version("0.2.4"))
        XCTAssertFalse(version > Version("1.2.4.5"))
        XCTAssertFalse(version > Version("1.2"))
    }

    static var allTests = [
        ("testCreate", testCreate),
        ("testShorterVersion", testShorterVersion),
        ("testLongerVersion", testLongerVersion),
        ("testExpressionEquality", testExpressionEquality),
        ("testExpressionless", testExpressionless),
        ("testExpressionMore", testExpressionMore),
    ]
}
