import Foundation
import AeroGearSync
import SwiftyJSON
import Starscream

/**
* A Differential Synchronization client that uses the WebSocket as the transport protocol.
*/
public class SyncClient<CS:ClientSynchronizer, D:DataStore where CS.T == D.T>: WebsocketDelegate {

    typealias T = CS.T
    var ws: Websocket!
    var documents = Dictionary<String, ClientDocument<T>>()
    let syncEngine: ClientSyncEngine<CS, D>

    /**
    Initializes a SyncClient.

    :param: url the URL of the sync server
    :param: syncEngine the ClientSyncEngine to be used by this SyncClient
    */
    public convenience init(url: String, syncEngine: ClientSyncEngine<CS, D>) {
        self.init(url: url, optionalProtocols: Optional.None, syncEngine: syncEngine)
    }

    /**
    Initializes a SyncClient.

    :param: url the URL of the sync server
    :param: protocols optional WebSocket protocols that the underlying WebSocket should use.
    :param: syncEngine the ClientSyncEngine to be used by this SyncClient
    */
    public convenience init(url: String, protocols: Array<String>, syncEngine: ClientSyncEngine<CS, D>) {
        self.init(url: url, optionalProtocols: protocols, syncEngine: syncEngine)
    }

    private init(url: String, optionalProtocols: Array<String>?, syncEngine: ClientSyncEngine<CS, D>) {
        self.syncEngine = syncEngine
        if let protocols = optionalProtocols {
            ws = Websocket(url: NSURL(string: url)!, protocols: protocols)
        } else {
            ws = Websocket(url: NSURL(string: url)!)
        }
        ws.delegate = self
    }

    /**
    Connects this SyncClient to the SyncServer

    :returns: self to support method chaining
    */
    public func connect() -> SyncClient {
        ws.connect()
        return self
    }

    /**
    Adds a document to this SyncClient.

    :param: doc the ClientDocument to add to this SyncClient
    :param: callback the callback that will be invoked with updates from the server.
    */
    public func addDocument(doc: ClientDocument<T>, callback: (ClientDocument<T>) -> ()) {
        syncEngine.addDocument(doc, callback: callback)
        ws.writeString(JsonConverter.asJson(doc))
    }

    /**
    Computes a diff of the passed in document with the version in this SyncClient and
    sends the resulting PatchMessage to the server.

    :param: doc the ClientDocument with updates to be diffed
    :returns: self to support method chaining
    */
    public func diffAndSend(doc: ClientDocument<T>) -> SyncClient {
        if let patchMessage = syncEngine.diff(doc) {
            ws.writeString(JsonConverter.asJson(patchMessage))
        }
        return self
    }

    /**
    Disconnects this SyncClient from the server.
    */
    public func disconnect() {
        ws.disconnect()
    }

    public func websocketDidReceiveMessage(text: String) {
        if let patchMessage = JsonConverter.asPatchMessage(text) {
            syncEngine.patch(patchMessage)
        } else {
            println("Recieved none patchMessage: \(text)")
        }
    }

    public func websocketDidConnect() {
        println("Websocket is connected")
    }
    
    public func websocketDidDisconnect(error: NSError?) {
        if let err = error {
            println("Websocket is disconnected with error: \(error!.localizedDescription)")
        } else {
            println("Websocket is disconnected")
        }
    }
    
    public func websocketDidWriteError(error: NSError?) {
        println("Error from the Websocket: \(error!.localizedDescription)")
    }
    
    public func websocketDidReceiveData(data: NSData) {
        println("Message: \(data)")
    }

}


