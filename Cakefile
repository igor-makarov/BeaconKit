project.name = 'BeaconKit'

swift_version = File.open('.swift-version', 'rb').read.strip

project.all_configurations.each do |configuration|
  configuration.settings['SWIFT_VERSION'] = swift_version unless swift_version.empty?
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
