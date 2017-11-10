#
# Be sure to run `pod lib lint ft_api_pod.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ft_api_pod'
  s.version          = '0.1.0'
  s.summary          = 'ft_api_pod will serve as a data retriever'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
ft_api_pod will be the middle man between the user backend and the 42 api
Pretty cool ey!
                       DESC

  s.homepage         = 'https://github.com/phjacobs7ag/ft_api_pod'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Eben Dorland && Phillip Jacobs' => 'phjacobs@student.42.fr' }
  s.source           = { :git => 'https://github.com/phjacobs7ag/ft_api_pod.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.2'

  s.source_files = 'ft_api_pod/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ft_api_pod' => ['ft_api_pod/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'Alomofire'

  # s.frameworks = 'UIKit', 'Alamofire' 'SwiftyJSON'
  s.dependency 'Alamofire' 'SwiftyJSON'
end
