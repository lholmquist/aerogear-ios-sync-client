import Foundation
import AeroGearSync
import SwiftyJSON

public class SyncClient: WebsocketDelegate {

    var ws: Websocket!
    
    public init(url: String) {
        ws = Websocket(url: NSURL(string: url))
        ws.delegate = self
    }

    public init(url: String, protocols: Array<String>) {
        ws = Websocket(url: NSURL(string: url), protocols: protocols)
        ws.delegate = self
    }

    public func connect() {
        ws.connect()
    }
    
    public func close() {
        ws.disconnect()
    }

    func websocketDidConnect() {
        println("Websocket is connected")
    }
    func websocketDidDisconnect(error: NSError?) {
        println("Websocket is disconnected: \(error!.localizedDescription)")
    }
    func websocketDidWriteError(error: NSError?) {
        println("Error from the Websocket: \(error!.localizedDescription)")
    }
    func websocketDidReceiveMessage(text: String) {
        println("Message: \(text)")
    }
    
    func websocketDidReceiveData(data: NSData) {
        println("got some data: \(data.length)")
    }

    public func addDocument(doc: ClientDocument<String>) {
        ws.writeString(addMsgJson(doc))
    }

    func addMsgJson(doc: ClientDocument<String>) -> String {
        return "{\"msgType\": \"add\", \"id\": \"\(doc.id)\", \"clientId\": \"\(doc.clientId)\", \"content\": \"\(doc.content)\"}";
    }
    
}


