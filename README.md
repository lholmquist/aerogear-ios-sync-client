# AeroGear iOS Differential Synchronization Client 
This project represents a client side implementation for [AeroGear Differential 
Synchronization (DS) Server](https://github.com/danbev/aerogear-sync-server/tree/differential-synchronization).

This client uses the communication with the backend server implementation. The [iOS SyncEngine](https://github.com/danbev/aerogear-ios-sync)
performs the actual work of the DiffSync protocol, please refer to it's README.md for more details.

## Prerequisites 
This project requires Xcode 6.0 to run.

This project also uses a git submodule as a temporary solution until we can have Swift project in Cocoapods. The submodule need to be
initialized and updated:

    git submodule init
    git submodule update

Now, it is even worst that our submodule also contains a submodule (sorry):

    cd aerogear-ios-sync
    git submodule init
    git submodule update

## Building

Building can be done by opening the project in Xcode:

    open AeroGearSyncClient.xcworkspace

or you can use the command line:

    xcodebuild -workspace AeroGearSyncClient.xcworkspace/ -scheme AeroGearSyncClient -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO

## Testing
Tests can be run from with in Xcode using Product->Test menu option (CMD+U).  
You can also run test from the command:

    xcodebuild -workspace AeroGearSyncClient.xcworkspace/ -scheme AeroGearSyncClient -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO test

_Note_ At the moment the test require that the [AeroGear Differential Synchronization (DS) Server](https://github.com/danbev/aerogear-sync-server/tree/differential-synchronization).
is running. If it is not en error message simliar to this will be displayed:
```shell
aerogear-ios-sync-client/AeroGearSyncClientTests/SyncClientTests.swift:44: error: -[AeroGearSyncClientTests.SyncClientTests testDiffAndSync] : Asynchronous wait failed: Exceeded timeout of 3 seconds, with unfulfilled expectations: "Callback should be invoked. Is the Sync Server running?".
```






    

