#
# Be sure to run `pod lib lint TweakologyEngine.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TweakologyEngine'
  s.version          = '0.1.8'
  s.summary          = 'Tweakology`s engine to update app layout from configuration at runtime'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Tweakology`s engine to update app layout from configuration at runtime
                       DESC

  s.homepage         = 'https://github.com/Velikolay/tweakology'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Nikolay Ivanov' => 'velikolay@gmail.com' }
  s.source           = { :git => 'https://github.com/Velikolay/tweakology.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.swift_version = '4.2'
  s.ios.deployment_target = '9.0'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.source_files = 'TweakologyEngine/Classes/**/*'

  s.dependency 'GCDWebServer', '~> 3.0'
  s.dependency 'ObjectMapper', '~> 3.4.1'
  s.dependency 'SDWebImage', '~> 4.0'
  s.subspec 'CryptoHash' do |ss|
    ss.source_files = 'CryptoHash/**/*.{h,m}'
    ss.exclude_files = 'CryptoHash/Example/build/**/*'
  end
  s.subspec 'LiquidKit' do |ss|
      ss.source_files = 'TweakologyLiquidKit/Sources/LiquidKit/*.{h,m,swift}'
      ss.dependency 'STRFTimeFormatter'
  end
  s.resources  = "TweakologyEngine/**/*.xcassets"

  s.test_spec 'Tests' do |ts|
      ts.source_files = 'TweakologyEngine/Tests/**/*'
      ts.dependency 'Nimble', '~> 8.0'
  end
  # s.resource_bundles = {
  #   'TweakologyEngine' => ['TweakologyEngine/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
