//
//  JsonConverterTests.swift
//  AeroGearSyncClient
//
//  Created by Daniel Bevenius on 27/10/14.
//  Copyright (c) 2014 Daniel Bevenius. All rights reserved.
//
import UIKit
import XCTest
import AeroGearSyncClient
import AeroGearSync

class JsonConverterTests: XCTestCase {

    typealias Json = JsonConverter.Json

    let patchJson : Json = [
        "msgType": "patch", "clientId": "patchTest", "id": "1234",
        "edits": [[
            "clientVersion": -1,
            "serverVersion": 0,
            "checksum": "",
            "diffs": [["operation": "UNCHANGED", "text": "Fletch"], ["operation": "ADD", "text": "2"]]
        ]]
    ]

    class StringContentSerializer : ContentSerializer {
        func asString(content: String) -> String {
            return "\"" + content + "\""
        }
    }
    class JsonContentSerializer : ContentSerializer {
        func asString(content: Json) -> String {
            return JsonConverter.asJsonString(content)!
        }
    }
    let stringContentSerializer = StringContentSerializer()
    let jsonContentSerializer = JsonContentSerializer()


    func testAddMsgJsonStringContent() {
        let json = JsonConverter.addMsgJson(ClientDocument<String>(id: "1234", clientId: "jsonClient", content: "Fletch"), serializer: stringContentSerializer)
        let dict = JsonConverter.asDictionary(json)!
        XCTAssertEqual(dict["msgType"] as String, "add")
        XCTAssertEqual(dict["id"] as String, "1234")
        XCTAssertEqual(dict["clientId"] as String, "jsonClient")
        XCTAssertEqual(dict["content"] as String, "Fletch")
    }

    func testAddMsgJsonContent() {
        let content = ["name": "Fletch"]
        var json = JsonConverter.addMsgJson(ClientDocument<Json>(id: "1234", clientId: "jsonClient", content: content), serializer: jsonContentSerializer)
        let dict = JsonConverter.asDictionary(json)!
        XCTAssertEqual(dict["msgType"] as String, "add")
        XCTAssertEqual(dict["id"] as String, "1234")
        XCTAssertEqual(dict["clientId"] as String, "jsonClient")
        let convertedContent = dict["content"] as Json
        XCTAssertEqual(convertedContent["name"] as String, "Fletch")
    }

    func testPatchMsgJson() {
        let json = JsonConverter.patchMsgAsJson(patchMessage())
        let dict = JsonConverter.asDictionary(json)!

        XCTAssertEqual(dict["msgType"] as String, "patch")
        XCTAssertEqual(dict["id"] as String, "1234")
        XCTAssertEqual(dict["clientId"] as String, "patchTest")

        let edits = dict["edits"] as Array<Json>
        XCTAssertEqual(edits.count, 1)
        let edit = edits.first! as Json
        XCTAssertEqual(edit["serverVersion"] as Int, 0)
        XCTAssertEqual(edit["clientVersion"] as Int, -1)
        XCTAssertEqual(edit["checksum"] as String, "")

        let diffs = edit["diffs"] as Array<Json>
        XCTAssertEqual(diffs.count, 2)
        XCTAssertEqual(diffs[0]["operation"] as String, Edit.Operation.Unchanged.rawValue)
        XCTAssertEqual(diffs[0]["text"] as String, "Fletch")
        XCTAssertEqual(diffs[1]["operation"] as String, Edit.Operation.Add.rawValue)
        XCTAssertEqual(diffs[1]["text"] as String, "2")
    }

    func testToPatchMessage() {
        let expected = patchMessage()
        let actual = JsonConverter.asPatchMessage(JsonConverter.asJsonString(patchJson)!)!
        XCTAssertEqual(expected.documentId, actual.documentId)
        XCTAssertEqual(expected.clientId, actual.clientId)
        XCTAssertEqual(expected.edits.count, actual.edits.count)
        XCTAssertEqual(expected.edits[0].clientVersion, actual.edits[0].clientVersion)
        XCTAssertEqual(expected.edits[0].serverVersion, actual.edits[0].serverVersion)
        XCTAssertEqual(expected.edits[0].checksum, actual.edits[0].checksum)
        XCTAssertEqual(expected.edits[0].diffs.count, actual.edits[0].diffs.count)
        XCTAssertEqual(expected.edits[0].diffs[0].operation, Edit.Operation.Unchanged)
        XCTAssertEqual(expected.edits[0].diffs[0].text, "Fletch")
        XCTAssertEqual(expected.edits[0].diffs[1].operation, Edit.Operation.Add)
        XCTAssertEqual(expected.edits[0].diffs[1].text, "2")
    }

    private func patchMessage() -> PatchMessage {
        var diffs = Array<Edit.Diff>()
        diffs.append(Edit.Diff(operation: Edit.Operation.Unchanged, text: "Fletch"))
        diffs.append(Edit.Diff(operation: Edit.Operation.Add, text: "2"))
        let edit = Edit(clientId: "patchTest", documentId: "1234", clientVersion: -1, serverVersion: 0, checksum: "", diffs: diffs)
        var edits = Array<Edit>()
        edits.append(edit)
        return PatchMessage(id: "1234", clientId: "patchTest", edits: edits)
    }

}
