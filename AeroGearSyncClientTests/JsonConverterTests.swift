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

    let patchMessageJson =
            "{\"msgType\":\"patch\",\"clientId\":\"patchTest\",\"id\":\"1234\",\"edits\":[" +
                    "{\"clientVersion\":-1" +
                    ",\"serverVersion\":0" +
                    ",\"checksum\":\"\"" +
                    ",\"diffs\":[" +
                        "{\"operation\":\"UNCHANGED\",\"text\":\"Fletch\"}," +
                        "{\"operation\":\"ADD\",\"text\":\"2\"}" +
                    "]}" +
                "]" +
            "}"

    func testAsJsonClientDocument() {
        XCTAssertEqual("{\"msgType\": \"add\", \"id\": \"1234\", \"clientId\": \"jsonClient\", \"content\": \"Fletch\"}",
            JsonConverter.asJson(ClientDocument<String>(id: "1234", clientId: "jsonClient", content: "Fletch")))
    }

    func testAsJsonPatchMessage() {
        XCTAssertEqual(patchMessageJson, JsonConverter.asJson(patchMessage()))
    }

    func testToPatchMessage() {
        let expected = patchMessage()
        let actual = JsonConverter.asPatchMessage(patchMessageJson)!
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
