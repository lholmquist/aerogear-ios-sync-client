//
//  JsonConverter.swift
//  AeroGearSyncClient
//
//  Created by Daniel Bevenius on 27/10/14.
//  Copyright (c) 2014 Daniel Bevenius. All rights reserved.
//

import Foundation
import AeroGearSync
import SwiftyJSON

public class JsonConverter {

    public typealias Json = Dictionary<String, AnyObject>

    /**
    Returns a JSON add message type for the passed-in ClientDocument

    :param: doc the ClientDocument to convert into JSON
    :returns: the JSON representation of the ClientDocument
    */
    public class func addMsgJson<T, S:ContentSerializer where T == S.T>(doc: ClientDocument<T>, serializer: S) -> String {
        var str = "{\"msgType\":\"add\",\"id\":\"" + doc.id + "\",\"clientId\":\"" + doc.clientId + "\""
        str += ",\"content\":" + serializer.asString(doc.content)
        str += "}"
        return str
    }

    /**
    Returns a JSON patch message type for the passed-in ClientDocument

    :param: doc the ClientDocument to convert into JSON
    :returns: the JSON representation of the PatchMessage
    */
    public class func patchMsgAsJson(patchMsg: PatchMessage) -> String {
        // TODO: This should be solved on the server side.
        var str = "{\"msgType\":\"patch\",\"id\":\"" + patchMsg.documentId + "\",\"clientId\":\"" + patchMsg.clientId + "\""
        str += ",\"edits\":["
        let count = patchMsg.edits.count-1
        for i in 0...count {
            let edit = patchMsg.edits[i]
            str += "{\"clientVersion\":\(edit.clientVersion)"
            str += ",\"serverVersion\":\(edit.serverVersion)"
            str += ",\"checksum\":\"\(edit.checksum)"
            str += "\",\"diffs\":["
            let diffscount = edit.diffs.count-1
            for y in 0...diffscount {
                let text = edit.diffs[y].text.stringByReplacingOccurrencesOfString("\"", withString: "\\\"", options: NSStringCompareOptions.LiteralSearch, range: nil)
                str += "{\"operation\":\"" + edit.diffs[y].operation.rawValue + "\",\"text\":\"" + text + "\"}"
                if y != diffscount {
                    str += ","
                }
            }
            str += "]}]}"
        }
        return str
    }

    /**
    Converts a JSON respresentation of a PatchMessage into a PatchMessage object.

    :param: jsonString the JSON respresentation of a PatchMessage
    :returns: an optional PatchMessage object instance, or Optional.None if a conversion error occured
    */
    public class func asPatchMessage(jsonString: String) -> PatchMessage? {
        if let dict = asDictionary(jsonString) {
            let json = JSON(dict)
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

    /**
    Tries to convert the passed in String into a Swift Dictionary<String, AnyObject>

    :param: jsonString the JSON string to convert into a Dictionary
    :returns: Optional Dictionary<String, AnyObject>
    */
    public class func asDictionary(jsonString: String) -> Dictionary<String, AnyObject>? {
        var jsonErrorOptional: NSError?
        return NSJSONSerialization.JSONObjectWithData((jsonString as NSString).dataUsingEncoding(NSUTF8StringEncoding)!,
            options: NSJSONReadingOptions(0), error: &jsonErrorOptional) as? Dictionary<String, AnyObject>
    }

    /**
    Tries to convert the passed in Dictionary<String, AnyObject> into a JSON String representation.

    :param: the Dictionary<String, AnyObject> to try to convert.
    :returns: optionally the JSON string representation for the dictionary.
    */
    public class func asJsonString(dict: Dictionary<String, AnyObject>) -> String? {
        return JSON(dict).rawString(encoding: NSUTF8StringEncoding, options: nil)!
    }

}
