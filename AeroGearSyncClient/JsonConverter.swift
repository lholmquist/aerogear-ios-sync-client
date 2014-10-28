//
//  JsonConverter.swift
//  AeroGearSyncClient
//
//  Created by Daniel Bevenius on 27/10/14.
//  Copyright (c) 2014 Daniel Bevenius. All rights reserved.
//

import Foundation
import AeroGearSync

public class JsonConverter {

    public class func asJson<T>(doc: ClientDocument<T>) -> String {
        return "{\"msgType\": \"add\", \"id\": \"\(doc.id)\", \"clientId\": \"\(doc.clientId)\", \"content\": \"\(doc.content)\"}";
    }

    public class func asJson(patchMsg: PatchMessage) -> String {
        var json = "{";
        json += "\"msgType\":\"patch\","
        json += "\"clientId\":\"\(patchMsg.clientId)\""
        json += ",\"id\":\"\(patchMsg.documentId)\""
        json += ",\"edits\":["
        let edits = patchMsg.edits
        for edit in edits {
            json += "{\"clientVersion\":\(edit.clientVersion)"
            json += ",\"serverVersion\":\(edit.serverVersion)"
            json += ",\"checksum\":\"\(edit.checksum)\""
            json += ",\"diffs\":["
            let diffs = edit.diffs
            var i = 0;
            for i = 0; i < diffs.count; i++ {
                json += "{\"operation\":\"\(diffs[i].operation.rawValue)\""
                json += ",\"text\":\"\(diffs[i].text)\"}"
                if i != diffs.count-1 {
                    json += ","
                }
            }
            json += "]"
            json += "}"
        }
        json += "]"
        json += "}";
        return json
    }

    public class func asPatchMessage(jsonString: String) -> PatchMessage? {
        var jsonErrorOptional: NSError?
        let jsonOptional = NSJSONSerialization.JSONObjectWithData((jsonString as NSString).dataUsingEncoding(NSUTF8StringEncoding)!,
            options: NSJSONReadingOptions(0), error: &jsonErrorOptional) as? NSDictionary
        if let dictionary = jsonOptional {
            let json = JSON(dictionary)
            let id = json["id"].string!
            let clientId = json["clientId"].string!
            var edits = Array<Edit>()
            for (key: String, jsonEdit) in json["edits"] {
                var diffs = Array<Edit.Diff>()
                for (key: String, jsonDiff: JSON) in jsonEdit["diffs"] {
                    diffs.append(Edit.Diff(operation: Edit.Operation(rawValue: jsonDiff["operation"].stringValue)!,
                        text: jsonDiff["text"].stringValue))
                }
                edits.append(Edit(clientId: clientId,
                    documentId: id,
                    clientVersion: jsonEdit["clientVersion"].number! as Int,
                    serverVersion: jsonEdit["serverVersion"].number! as Int,
                    checksum: jsonEdit["checksum"].string!,
                    diffs: diffs))

            }
            return PatchMessage(id: id, clientId: clientId, edits: edits)
        }
        return Optional.None
    }

}
