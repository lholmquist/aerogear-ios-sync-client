Pod::Spec.new do |s|
  s.name         = "AeroGearSyncClient"
  s.version      = "0.1.0"
  s.summary      = "An iOS Sync Client for AeroGear Differential Synchronization"
  s.homepage     = "https://github.com/aerogear/aerogear-sync-server"
  s.license      = {:type => 'Apache License, Version 2.0', :file => 'LICENCE.txt'}
  s.author       = "Red Hat, Inc."
  s.source       = {:git => 'https://github.com/danbev/aerogear-ios-sync-client.git',  :branch => 'cocoapods'}
  s.platform     = :ios, 8.0
  s.source_files = 'AeroGearSync/*.{swift}'
  s.dependency  'AeroGearSync', '0.1.0'
  s.dependency  'Starscream', '0.9.1'
  s.dependency  'SwiftyJSON', '2.1.2'
end
