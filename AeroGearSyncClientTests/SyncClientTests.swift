import UIKit
import XCTest
import AeroGearSyncClient

class SyncClientTests: XCTestCase {
    
    func testExample() {
        let syncClient = SyncClient(name: "Fletch")
        XCTAssertEqual("Fletch", syncClient.name)
    }
    
}
