# AeroGear iOS Differential Synchronization Client 
This project represents a client side implementation for [AeroGear Differential 
Synchronization (DS) Server](https://github.com/danbev/aerogear-sync-server/tree/differential-synchronization).

This client uses the communication with the backend server implementation. The [iOS SyncEngine](https://github.com/danbev/aerogear-ios-sync)
performs the actual work of the DiffSync protocol, please refer to it's README.md for more details.

## Prerequisites 
This project requires Xcode 6.0 to run.

This project uses [Cocoapods](http://cocoapods.org/) to manage dependencies. You need to install the dependencies before building and
using the project:

    pod install

## Building

Building can be done by opening the project in Xcode:

    open AeroGearSyncClient.xcodeproj

or you can use the command line:

    xcodebuild -workspace AeroGearSyncClient.xcworkspace/ -scheme AeroGearSyncClient -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO

## Testing
Tests can be run from with in Xcode using Product->Test menu option (CMD+U).  
You can also run test from the command:

    xcodebuild -workspace AeroGearSyncClient.xcworkspace/ -scheme AeroGearSyncClient -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO test






    

