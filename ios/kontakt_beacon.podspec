#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint kontakt_beacon.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'kontakt_beacon'
  s.version          = '0.0.1'
  s.summary          = 'A Plugin for Kontakt Beacon Implementation'
  s.description      = <<-DESC
A Plugin for Kontakt Beacon Implementation
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Vaifat Huy' => 'vaifathuy@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'KontaktSDK', '~> 1.3'
  s.platform = :ios, '10.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
