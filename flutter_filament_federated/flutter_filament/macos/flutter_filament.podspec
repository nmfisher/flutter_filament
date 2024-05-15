#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_filament.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_filament'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/*', 'include/ResourceBuffer.hpp','include/SwiftFlutterFilamentPlugin-Bridging-Header.h'
  s.public_header_files = 'include/SwiftFlutterFilamentPlugin-Bridging-Header.h', 'include/ResourceBuffer.hpp'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '13'
  
  s.pod_target_xcconfig = { 
    'DEFINES_MODULE' => 'YES', 
    'OTHER_CFLAGS' => '"-fvisibility=default" "$(inherited)"',
  }
  s.swift_version = '5.0'
  
end
