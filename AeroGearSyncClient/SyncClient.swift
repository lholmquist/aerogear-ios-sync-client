import Foundation
import AeroGearSync
import SwiftyJSON

public class SyncClient: NSObject, SRWebSocketDelegate {

    var ws: SRWebSocket!

    public init(url: String) {
        ws = SRWebSocket(URL: NSURL(string: url))
        super.init()
        ws.delegate = self
    }

    public func connect() {
        ws.open()
    }

    public func close() {
        ws.close()
    }

    public func addDocument<T>(clientDocument: ClientDocument<T>) {
        if readyState() == ReadyState.Open {
            let json = JSON(object: clientDocument)
            println("JSON: \(json)")
        } else {
            println("not connected!!!")
        }
    }
    
    public func webSocketDidOpen(webSocket: SRWebSocket) {
        
    }

    public func webSocket(webSocket: SRWebSocket!, didReceiveMessage message: AnyObject!) {
        if let messageString = message as? String {
            println("Message: \(messageString)")
        }
    }

    public func webSocket(webSocket: SRWebSocket!, didFailWithError error: NSError!) {
        println("Message: \(error)")
    }

    func webSocket(webSocket: SRWebSocket!, didCloseWithCode code: Int!, reason:String!, wasClean:Bool!) {
        println("Closed: code=\(code) reason=\(reason)")
    }

    private func readyState() -> ReadyState {
        if ws != nil {
            switch ws.readyState.value {
            case 0:
                return ReadyState.Connecting
            case 1:
                return ReadyState.Open
            case 2:
                return ReadyState.Closing
            case 3:
                return ReadyState.Closed
            default:
                return ReadyState.Unknown
            }
        }
        return ReadyState.Unknown
    }

    private enum ReadyState: Int {
        case Connecting = 0
        case Open = 1
        case Closing = 2
        case Closed = 3
        case Unknown = -1
    }
}


