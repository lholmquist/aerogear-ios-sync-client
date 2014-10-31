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

    public typealias Json = Dictionary<String, AnyObject>

    /**
    Returns a JSON add message type for the passed-in ClientDocument

    :param: doc the ClientDocument to convert into JSON
    :returns: the JSON representation of the ClientDocument
    */
    public class func addMsgJson<T>(doc: ClientDocument<T>) -> String {
        var dict: Json = ["msgType": "add", "id": doc.id, "clientId": doc.clientId]
        if doc.content is Json {
            dict["content"] = doc.content as Json
        } else if doc.content is String {
            dict["content"] = doc.content as String
        }
        return JSON(dict).rawString(encoding: NSUTF8StringEncoding, options: nil)!
    }

    /**
    Returns a JSON patch message type for the passed-in ClientDocument

    :param: doc the ClientDocument to convert into JSON
    :returns: the JSON representation of the PatchMessage
    */
    public class func patchMsgJson(patchMsg: PatchMessage) -> String {
        var json: Json = ["msgType": "patch", "id": patchMsg.documentId, "clientId": patchMsg.clientId]
        var jsonEdits: Array<Json> = Array()
        for edit in patchMsg.edits {
            var edits: Json = ["clientVersion": edit.clientVersion, "serverVersion": edit.serverVersion, "checksum": edit.checksum]
            var diffs: Array<Json> = Array()
            for diff in edit.diffs {
                diffs.append(["operation": diff.operation.rawValue, "text": diff.text])
            }
            edits["diffs"] = diffs
            jsonEdits.append(edits)
        }
        json["edits"] = jsonEdits
        return JSON(json).rawString(encoding: NSUTF8StringEncoding, options: nil)!
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
    public func asJsonString(dict: Dictionary<String, AnyObject>) -> String? {
        return JSON(dict).rawString(encoding: NSUTF8StringEncoding, options: nil)!
    }

}
