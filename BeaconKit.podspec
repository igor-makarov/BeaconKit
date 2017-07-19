filename = File.basename(__FILE__, ".podspec")

Pod::Spec.new do |s|

  s.name         = "#{filename}"
  s.version      = "0.0.1"
  s.summary      = "iOS Beacon framework using BTLE"

  s.description  = <<-DESC
iOS Beacon framework using BTLE
Scan for Eddystone-UID, Eddystone-URL & AltBeacon
                   DESC
  s.homepage     = "https://github.com/igor-makarov/BeaconKit"
  s.license      = "MIT"
  s.author             = { "Igor Makarov" => "igormaka@gmail.com" }
  s.source = { :git => 'https://github.com/igor-makarov/BeaconKit.git', :tag => "#{s.version}" }

  s.default_subspecs = ['Core']
  s.ios.deployment_target = "9.0"
  s.watchos.deployment_target = "2.0"

  s.subspec 'Core' do |sp|
    sp.source_files = "Sources/Core/**/*.{h,m,swift}"
  end


end
