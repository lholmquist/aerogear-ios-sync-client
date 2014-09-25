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
        //self.socket.writeString(text) //example on how to write a string the socket
    }
    
    func websocketDidReceiveData(data: NSData) {
        println("got some data: \(data.length)")
        //self.socket.writeData(data) //example on how to write binary data to the socket
    }

    public func addDocument<T>(clientDocument: ClientDocument<T>) {
        let json = JSON(object: clientDocument)
        println("JSON: \(json)")
        ws.writeString(json.description)
    }
    
}


