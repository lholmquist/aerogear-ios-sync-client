import UIKit
import XCTest
import AeroGearSyncClient
import AeroGearSync

class SyncClientTests: XCTestCase {
    
    func testAddDocument() {
        let syncClient = SyncClient(serverUrl: "http://localhost:7777/simplepush")
        XCTAssertEqual("http://localhost:7777/simplepush", syncClient.serverUrl)
        let document = ClientDocument<String>(id: "1234", clientId: "iosClient", content: "Fletch")
        syncClient.addDocument(document)
    }
    
}
