import UIKit
import XCTest
import AeroGearSyncClient
import AeroGearSync

class SyncClientTests: XCTestCase {
    
    typealias T = JsonConverter.Json
    var dataStore: InMemoryDataStore<T>!
    var synchonizer: JsonDiffMatchPatchSynchronizer!
    var engine: ClientSyncEngine<JsonDiffMatchPatchSynchronizer, InMemoryDataStore<T>>!

    override func setUp() {
        super.setUp()
        self.dataStore = InMemoryDataStore()
        self.synchonizer = JsonDiffMatchPatchSynchronizer()
        self.engine = ClientSyncEngine(synchronizer: synchonizer, dataStore: dataStore)
    }

    func testAddDocument() {
        let syncClient = SyncClient(url: "http://localhost:7777/sync", syncEngine: engine)
        let id = NSUUID().UUIDString
        let content = ["name": "Fletch"]
        let callback = {(doc: ClientDocument<T>) -> () in }
        syncClient.connect().addDocument(ClientDocument<T>(id: id, clientId: "iosClient", content: content), callback)
        sleep(3)
        let added = dataStore.getClientDocument(id, clientId: "iosClient")
        XCTAssertEqual(id, added!.id)
        XCTAssertEqual("iosClient", added!.clientId)
        XCTAssertEqual(content["name"]! as String, added!.content["name"] as String)
        syncClient.disconnect()
    }
    
    func testDiffAndSync() {
        let expectation = expectationWithDescription("Callback should be invoked. Is the Sync Server running?")
        let id = NSUUID().UUIDString

        let content = ["name": "Fletch"]
        let update = ["name": "Fletch2"]
        let syncClient = SyncClient(url: "http://localhost:7777/sync", syncEngine: engine)
        let callback = {(doc: ClientDocument<T>) -> () in
            println("Testing callback: received: \(doc.content)")
            XCTAssertEqual(doc.content["name"]! as String, "Fletch2")
            expectation.fulfill()
        }
        syncClient.connect().addDocument(ClientDocument<T>(id: id, clientId: "iosClient", content: content), callback)
        syncClient.diffAndSend(ClientDocument<T>(id: id, clientId: "iosClient", content: update))
        waitForExpectationsWithTimeout(3.0, handler:nil)
        syncClient.disconnect()
    }

}
