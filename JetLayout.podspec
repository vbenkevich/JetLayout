#
# Be sure to run `pod lib lint JetLayout.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JetLayout'
  s.version          = '0.2.1'
  s.summary          = 'JetLayout is a swift based layout system.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
JetLayout is a swift based layout system. It has a syntax like SwiftUI, but JetLayout could be used with iOS 11.
Layout engine is based on Autolayout, so JetLayout's widgets could be easily integrated into an existing application.
RxSwift is used to wiring UI and data.
Since all layouts has written in code it possible to use plugins like R.swift to provide strong typed access to assets.
                       DESC

  s.homepage         = 'https://github.com/vbenkevich/JetLayout'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'vbenkevich' => 'vladimir.benkevich@gmail.com' }
  s.source           = { :git => 'https://github.com/vbenkevich/JetLayout.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'

  s.source_files = 'JetLayout/Classes/**/*'
  s.frameworks = 'UIKit'
  s.dependency 'RxCocoa', '~> 5.1.1'
end
