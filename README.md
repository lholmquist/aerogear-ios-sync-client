# AeroGear iOS Differential Synchronization Client 
This project represents a client side implementation for [AeroGear Differential 
Synchronization (DS) Server](https://github.com/danbev/aerogear-sync-server/tree/differential-synchronization).

This client uses the communication with the backend server implementation. The [iOS SyncEngine](https://github.com/danbev/aerogear-ios-sync)
performs the actual work of the DiffSync protocol, please refer to it's README.md for more details.

## Prerequisites 
This project requires Xcode 6.0 to run.

## Building

Building can be done by opening the project in Xcode:

    open AeroGearSyncClient.xcodeproj

or you can use the command line.
Make sure you are using Xcode6.0: 

    xcodebuild -scheme AeroGearSyncClient build

## Testing
Tests can be run from with in Xcode using Product->Test menu option (CMD+U).  
You can also run test from the command:

    xcodebuild -scheme AeroGearSyncClient -destination 'platform=iOS Simulator,name=iPhone 5s' test






    

