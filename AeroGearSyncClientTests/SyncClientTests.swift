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
        syncClient.close()
        let added = dataStore.getClientDocument("1234", clientId: "iosClient")
        XCTAssertEqual("1234", added!.id)
        XCTAssertEqual("iosClient", added!.clientId)
        XCTAssertEqual("Fletch", added!.content)
    }
    
    func testDiffAndSync() {
        let syncClient = SyncClient(url: "http://localhost:7777/sync", syncEngine: engine)
        let callback = {(doc: ClientDocument<T>) -> () in
            println ("Testing callback: received: \(doc)")
        }
        syncClient.connect().addDocument(ClientDocument<T>(id: "1234", clientId: "iosClient", content: "Fletch"), callback)
        sleep(3)
        syncClient.diffAndSend(ClientDocument<T>(id: "1234", clientId: "iosClient", content: "Fletch2"))
    }

}
