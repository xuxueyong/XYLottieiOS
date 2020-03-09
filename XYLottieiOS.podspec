#
# Be sure to run `pod lib lint XYLottieiOS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XYLottieiOS'
  s.version          = '0.0.1'
  s.summary          = 'A short description of XYLottieiOS.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/794334810@qq.com/XYLottieiOS'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '794334810@qq.com' => 'xueyong_xu@yunzhijia.com' }
  s.source           = { :git => 'https://github.com/794334810@qq.com/XYLottieiOS.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'XYLottieiOS/Classes/**/*'
  
  # s.resource_bundles = {
  #   'XYLottieiOS' => ['XYLottieiOS/Assets/*.png']
  # }

  s.public_header_files = 'Pod/Classes/PublicHeaders/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
