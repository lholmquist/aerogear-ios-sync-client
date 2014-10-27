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

    func testAsJsonClientDocument() {
        XCTAssertEqual("{\"msgType\": \"add\", \"id\": \"1234\", \"clientId\": \"jsonClient\", \"content\": \"Fletch\"}",
            JsonConverter.asJson(ClientDocument<String>(id: "1234", clientId: "jsonClient", content: "Fletch")))
    }

    func testAsJsonPatchMessage() {
        var diffs = Array<Edit.Diff>()
        diffs.append(Edit.Diff(operation: Edit.Operation.Unchanged, text: "Fletch"))
        diffs.append(Edit.Diff(operation: Edit.Operation.Add, text: "2"))
        let edit = Edit(clientId: "patchTest", documentId: "1234", clientVersion: 0, serverVersion: 0, checksum: "", diffs: diffs)
        var edits = Array<Edit>()
        edits.append(edit)
        let patchMessage = PatchMessage(id: "1234", clientId: "patchTest", edits: edits)
        XCTAssertEqual(
            "{\"msgType\":\"patch\",\"clientId\":\"patchTest\",\"id\":\"1234\",\"edits\":[" +
                    "{\"clientVersion\":\"0\"" +
                    ",\"serverVersion\":\"0\"" +
                    ",\"checksum\":\"\"" +
                    ",\"diffs\":[" +
                        "{\"operation\":\"UNCHANGED\",\"text\":\"Fletch\"}," +
                        "{\"operation\":\"ADD\",\"text\":\"2\"}" +
                    "]}" +
                "]" +
            "}",
            JsonConverter.asJson(patchMessage))
    }

}
