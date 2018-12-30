#!/usr/bin/env ruby

source 'https://cdn.jsdelivr.net/cocoa/'

install! 'cocoapods',
         :deterministic_uuids => false
use_frameworks!

workspace 'BeaconKit'
project 'BeaconKit.xcodeproj'

abstract_target 'Common' do
  pod 'BeaconKit', :path => './', :testspecs => ['Tests']
  abstract_target 'iOS' do
    platform :ios, '9.0'
    pod 'SwiftLint'

    # target 'BeaconKitTests-iOS' do 
    # end
    target 'BeaconKitSample'
    target 'BeaconKitSampleObjC'
  end

  abstract_target 'macOS' do
    platform :osx, '10.12'

    target 'Beaconator'
    # target 'BeaconKitTests-macOS' do 
    # end
  end
end

post_install do |installer_representation|
  pods_project = installer_representation.pods_project

  if ENV['SWIFT_VERSION']
    SWIFT_VERSION = "#{ENV['SWIFT_VERSION']}.0"
  else 
    SWIFT_VERSION = File.open(".swift-version", "rb").read.strip
  end

  pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = SWIFT_VERSION
    end
  end
end