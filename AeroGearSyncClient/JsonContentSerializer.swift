//
//  JsonContentSerializer.swift
//  AeroGearSyncClient
//
//  Created by Daniel Bevenius on 04/11/14.
//  Copyright (c) 2014 Daniel Bevenius. All rights reserved.
//

import Foundation

public protocol JsonContentSerializer {

    class func asString(content: JsonConverter.Json) -> String

}
