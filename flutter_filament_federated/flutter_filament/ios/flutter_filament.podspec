#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_filament.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_filament'
  s.version          = '0.0.1'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/*', 'include/SwiftFlutterFilamentPlugin-Bridging-Header.h', 'include/ResourceBuffer.h'
  s.public_header_files = 'include/SwiftFlutterFilamentPlugin-Bridging-Header.h', 'include/ResourceBuffer.h'
  s.dependency 'Flutter' 
  s.platform = :ios, '13.0'
  s.static_framework = true
  s.user_target_xcconfig = { 
    'DEFINES_MODULE' => 'YES', 
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386', 
    "CLANG_CXX_LANGUAGE_STANDARD" => "c++17",
    'OTHER_CFLAGS' => '"-fvisibility=default" "$(inherited)"',
  }

  s.pod_target_xcconfig = { 
    'DEFINES_MODULE' => 'YES', 
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386', 
  }

  s.swift_version = '5.0'
end
