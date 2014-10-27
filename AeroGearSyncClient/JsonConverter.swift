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
            json += "{\"clientVersion\":\"\(edit.clientVersion)\""
            json += ",\"serverVersion\":\"\(edit.serverVersion)\""
            json += ",\"checksum\":\"\(edit.checksum)\""
            json += ",\"diffs\":["
            let diffs = edit.diffs
            var i = 0;
            for i = 0; i < diffs.count; i++ {
                json += "{\"operation\":\"\(diffs[i].operation.name())\""
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

}
