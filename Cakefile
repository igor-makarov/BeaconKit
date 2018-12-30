project.name = 'BeaconKit'

if ENV['SWIFT_VERSION']
  SWIFT_VERSION = "#{ENV['SWIFT_VERSION']}.0"
else 
  SWIFT_VERSION = File.open(".swift-version", "rb").read.strip
end

project.all_configurations.each do |configuration|
  configuration.settings['SWIFT_VERSION'] = SWIFT_VERSION
end

application_for :ios, 9.0 do |target|
  target.name = 'BeaconKitSample'
end

application_for :ios, 9.0 do |target|
  target.name = 'BeaconKitSampleObjC'
end

application_for :osx, 9.0 do |target|
  target.name = 'Beaconator'
end
