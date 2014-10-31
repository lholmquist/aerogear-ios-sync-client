import UIKit
import XCTest
import AeroGearSyncClient
import AeroGearSync

class SyncClientTests: XCTestCase {
    
    typealias T = String
    var dataStore: InMemoryDataStore<T>!
    var synchonizer: DiffMatchPatchSynchronizer!
    var engine: ClientSyncEngine<DiffMatchPatchSynchronizer, InMemoryDataStore<T>>!

    override func setUp() {
        super.setUp()
        self.dataStore = InMemoryDataStore()
        self.synchonizer = DiffMatchPatchSynchronizer()
        self.engine = ClientSyncEngine(synchronizer: synchonizer, dataStore: dataStore)
    }

    func testAddDocument() {
        let syncClient = SyncClient(url: "http://localhost:7777/sync", syncEngine: engine)
        let content = "{\"name\": \"Fletch\"}"
        let callback = {(doc: ClientDocument<T>) -> () in }
        syncClient.connect().addDocument(ClientDocument<T>(id: "1234", clientId: "iosClient", content: content), callback)
        sleep(3)
        let added = dataStore.getClientDocument("1234", clientId: "iosClient")
        XCTAssertEqual("1234", added!.id)
        XCTAssertEqual("iosClient", added!.clientId)
        XCTAssertEqual(content, added!.content)
        syncClient.disconnect()
    }
    
    func testDiffAndSync() {
        let expectation = expectationWithDescription("Callback should be invoked. Is the Sync Server running?")
        let id = NSUUID().UUIDString

        let content = "{\"name\": \"Fletch\"}"
        let update = "{\"name\": \"Fletch2\"}"
        let syncClient = SyncClient(url: "http://localhost:7777/sync", syncEngine: engine)
        let callback = {(doc: ClientDocument<T>) -> () in
            println("Testing callback: received: \(doc.content)")
            let content = JsonConverter.asDictionary(doc.content)!
            XCTAssertEqual(content["name"] as String, "Fletch2")
            expectation.fulfill()
        }
        syncClient.connect().addDocument(ClientDocument<T>(id: id, clientId: "iosClient", content: content), callback)
        syncClient.diffAndSend(ClientDocument<T>(id: id, clientId: "iosClient", content: update))
        waitForExpectationsWithTimeout(3.0, handler:nil)
        syncClient.disconnect()
    }

}
