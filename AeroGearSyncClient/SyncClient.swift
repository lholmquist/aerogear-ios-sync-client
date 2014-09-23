import Foundation

public class SyncClient {

    public let serverUrl: String
    var ws: SRWebSocket!

    public init(serverUrl: String) {
        self.serverUrl = serverUrl
    }

    public func connect() {
        ws = SRWebSocket(URL: NSURL(string: serverUrl))
        ws.open()
    }
    
    public func close() {
        ws.close()
    }
}


