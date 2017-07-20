#!/usr/bin/env ruby

install! 'cocoapods',
         :deterministic_uuids => false
platform :ios, '9.0'
use_frameworks!

workspace 'BeaconKit'
project 'BeaconKit.xcodeproj'

abstract_target 'BeaconKitCommon' do
  pod 'BeaconKit', :path => './'
  pod 'SwiftLint'

  target 'BeaconKitTests' do 
  end
  target 'BeaconKitSample'
  target 'BeaconKitSampleObjC'
end

post_install do |installer_representation|
  pods_project = installer_representation.pods_project

  pods_project.targets.each do |target|
  end
end