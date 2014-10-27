import Foundation
import AeroGearSync
import SwiftyJSON
import Starscream

public class SyncClient<CS:ClientSynchronizer, D:DataStore where CS.T == D.T>: WebsocketDelegate {

    typealias T = CS.T
    var ws: Websocket!
    var documents = Dictionary<String, ClientDocument<T>>()
    let syncEngine: ClientSyncEngine<CS, D>
    
    public convenience init(url: String, syncEngine: ClientSyncEngine<CS, D>) {
        self.init(url: url, optionalProtocols: Optional.None, syncEngine: syncEngine)
    }

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

    public func connect() -> SyncClient {
        ws.connect()
        return self
    }
    
    public func close() {
        ws.disconnect()
    }

    public func websocketDidConnect() {
        println("Websocket is connected")
    }
    
    public func websocketDidDisconnect(error: NSError?) {
        println("Websocket is disconnected: \(error!.localizedDescription)")
    }
    
    public func websocketDidWriteError(error: NSError?) {
        println("Error from the Websocket: \(error!.localizedDescription)")
    }
    
    public func websocketDidReceiveMessage(text: String) {
        println("Message: \(text)")
    }
    
    public func websocketDidReceiveData(data: NSData) {
        println("got some data: \(data.length)")
    }

    public func addDocument(doc: ClientDocument<T>, callback: (ClientDocument<T>) -> ()) {
        syncEngine.addDocument(doc, callback: callback)
        ws.writeString(addMsgJson(doc))
    }

    private func addMsgJson(doc: ClientDocument<T>) -> String {
        return "{\"msgType\": \"add\", \"id\": \"\(doc.id)\", \"clientId\": \"\(doc.clientId)\", \"content\": \"\(doc.content)\"}";
    }

}


