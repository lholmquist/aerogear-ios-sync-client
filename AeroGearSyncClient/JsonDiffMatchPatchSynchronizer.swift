//
//  JsonDiffMatchPatchSynchronizer.swift
//  AeroGearSyncClient
//
//  Created by Daniel Bevenius on 03/11/14.
//  Copyright (c) 2014 Daniel Bevenius. All rights reserved.
//

import Foundation
import AeroGearSync

public class JsonDiffMatchPatchSynchronizer: ClientSynchronizer {

    public typealias Json = JsonConverter.Json
    private let synchronizer: DiffMatchPatchSynchronizer

    public init() {
        self.synchronizer = DiffMatchPatchSynchronizer()
    }

    public func clientDiff(clientDocument: ClientDocument<Json>, shadow: ShadowDocument<Json>) -> Edit {
        return synchronizer.clientDiff(asStringDocument(clientDocument), shadow: asStringDocument(shadow))
    }

    public func patchDocument(edit: Edit, clientDocument: ClientDocument<Json>) -> ClientDocument<Json> {
        return asJsonDocument(synchronizer.patchDocument(edit, clientDocument: asStringDocument(clientDocument)))
    }

    public func patchShadow(edit: Edit, shadow: ShadowDocument<Json>) -> ShadowDocument<Json> {
        return asJsonDocument(synchronizer.patchShadow(edit, shadow: asStringDocument(shadow)))
    }

    public func serverDiff(serverDocument: ClientDocument<Json>, shadow: ShadowDocument<Json>) -> Edit {
        return synchronizer.serverDiff(asStringDocument(serverDocument), shadow: asStringDocument(shadow))
    }

    private func asStringDocument(doc: ClientDocument<Json>) -> ClientDocument<String> {
        let content = JsonConverter.asJsonString(doc.content) ?? ""
        return ClientDocument<String>(id: doc.id, clientId: doc.clientId, content: content)
    }

    private func asStringDocument(s: ShadowDocument<Json>) -> ShadowDocument<String> {
        let clientDoc = asStringDocument(s.clientDocument)
        return ShadowDocument<String>(clientVersion: s.clientVersion, serverVersion: s.serverVersion, clientDocument: clientDoc)
    }

    private func asJsonDocument(doc: ClientDocument<String>) -> ClientDocument<Json> {
        let content = JsonConverter.asDictionary(doc.content) ?? Dictionary<String, AnyObject>()
        return ClientDocument<Json>(id: doc.id, clientId: doc.clientId, content: content)
    }

    private func asJsonDocument(s: ShadowDocument<String>) -> ShadowDocument<Json> {
        let clientDoc = asJsonDocument(s.clientDocument)
        return ShadowDocument<Json>(clientVersion: s.clientVersion, serverVersion: s.serverVersion, clientDocument: clientDoc)
    }

}
