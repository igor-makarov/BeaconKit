#!/usr/bin/env ruby

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

  pods_project.targets.each do |target|
  end
end