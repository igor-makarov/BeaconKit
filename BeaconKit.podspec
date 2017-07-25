#!/usr/bin/env ruby
filename = File.basename(__FILE__, '.podspec')

Pod::Spec.new do |s|

  s.name         = "#{filename}"
  s.version      = '1.0.1'
  s.summary      = 'Beacon detection framework using CoreBluetooth'

  s.description  = <<~DESC
                    This is a framework that wraps around CoreBluetooth and detects beacons of different types.
                    Tested to compile with Swift 3.1, 3.2 & 4.0 for iOS 9.0 & macOS 10.12
                    The currently supported types are: Eddystone-UID, Eddystone-URL, AltBeacon, iBeacon.
                    DESC
  s.homepage     = 'https://github.com/igor-makarov/BeaconKit'
  s.license      = 'MIT'
  s.author       = { 'Igor Makarov' => 'igormaka@gmail.com' }
  s.source       = { :git => 'https://github.com/igor-makarov/BeaconKit.git', 
                     :tag => "#{s.version}" }

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.12'
  s.source_files = 'Sources/Core/**/*.swift'
end
