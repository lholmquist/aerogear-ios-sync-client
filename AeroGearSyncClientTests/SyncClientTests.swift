import UIKit
import XCTest
import AeroGearSyncClient
import AeroGearSync

class SyncClientTests: XCTestCase {
    
    func testAddDocument() {
        let syncClient = SyncClient(url: "http://localhost:7777/sync")
        syncClient.connect()
        let document = ClientDocument<String>(id: "1234", clientId: "iosClient", content: "Fletch")
        syncClient.addDocument(document)
        sleep(5)
    }
    
}
