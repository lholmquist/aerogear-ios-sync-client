import Foundation

public class SyncClient {

    public let serverUrl: String

    public init(serverUrl: String) {
        self.serverUrl = serverUrl
    }

    public func connect() {
        let ws = SRWebSocket(URL: NSURL(string: serverUrl))
        ws.open()
    }
}


