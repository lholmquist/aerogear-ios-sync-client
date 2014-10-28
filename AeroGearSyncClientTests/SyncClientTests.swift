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
        let callback = {(doc: ClientDocument<T>) -> () in
            println ("Testing callback: received: \(doc)")
        }
        syncClient.connect().addDocument(ClientDocument<T>(id: "1234", clientId: "iosClient", content: "Fletch"), callback)
        sleep(3)
        let added = dataStore.getClientDocument("1234", clientId: "iosClient")
        XCTAssertEqual("1234", added!.id)
        XCTAssertEqual("iosClient", added!.clientId)
        XCTAssertEqual("Fletch", added!.content)
        syncClient.close()
    }
    
    func testDiffAndSync() {
        let expectation = expectationWithDescription("Callback should be invoked. Is the Sync Server running?")

        let syncClient = SyncClient(url: "http://localhost:7777/sync", syncEngine: engine)
        let callback = {(doc: ClientDocument<T>) -> () in
            println("Testing callback: received: \(doc.content)")
            expectation.fulfill()
        }
        syncClient.connect().addDocument(ClientDocument<T>(id: "1234", clientId: "iosClient", content: "Fletch"), callback)
        syncClient.diffAndSend(ClientDocument<T>(id: "1234", clientId: "iosClient", content: "Fletch2"))
        waitForExpectationsWithTimeout(3.0, handler:nil)
        syncClient.close()
    }

}
