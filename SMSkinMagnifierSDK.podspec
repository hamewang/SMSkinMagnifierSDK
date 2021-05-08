#
# Be sure to run `pod lib lint SMSkinMagnifierSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SMSkinMagnifierSDK'
  s.version          = '1.1'
  s.summary          = 'moreme水肤镜SDK'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
moreme水肤镜SDK包含检测和报告
                       DESC

  s.homepage         = 'https://github.com/hamewang/SMSkinMagnifierSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'hamewang' => '304635659@qq.com' }
  s.source           = { :git => 'https://github.com/hamewang/SMSkinMagnifierSDK.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

#  s.source_files = 'SMSkinMagnifierSDK/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SMSkinMagnifierSDK' => ['SMSkinMagnifierSDK/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  s.resources = 'SMSkinMagnifierSDK/Assets/*.bundle'
  s.vendored_frameworks = 'SMSkinMagnifierSDK/Assets/*.framework'
  s.static_framework = true
   
  s.dependency 'CocoaAsyncSocket'
  s.dependency 'SDWebImage'
  s.dependency 'Masonry'
  s.dependency 'FMDB'
  s.dependency 'AliyunOSSiOS'
  s.dependency 'OpenCV'
  s.dependency 'SVProgressHUD'
  s.dependency 'MJExtension'
end
