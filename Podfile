#!/usr/bin/env ruby

source 'https://cdn.jsdelivr.net/cocoa/'

install! 'cocoapods',
         deterministic_uuids: false
use_frameworks!

workspace 'BeaconKit'
project 'BeaconKit.xcodeproj'

abstract_target 'Common' do
  pod 'BeaconKit', path: './', testspecs: ['Tests']
  abstract_target 'iOS' do
    platform :ios, '9.0'
    pod 'SwiftLint'

    target 'BeaconKitSample'
    target 'BeaconKitSampleObjC'
  end

  abstract_target 'macOS' do
    platform :osx, '10.12'

    target 'Beaconator'
  end
end

post_install do |installer_representation|
  pods_project = installer_representation.pods_project

  swift_version = File.open('.swift-version', 'rb').read.strip

  pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      next if swift_version.empty?

      config.build_settings['SWIFT_VERSION'] = swift_version
      STDERR.puts "Setting #{target.name} to Swift version: #{swift_version}"
    end
  end
end
