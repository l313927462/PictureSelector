#
# Be sure to run `pod lib lint PictureSelector.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PictureSelector'
  s.version          = '0.0.2'
  s.summary          = 'A short description of PictureSelector.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/313927462@qq.com/PictureSelector'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Magua' => '313927462@qq.com' }
  s.source           = { :git => 'git@github.com:l313927462/PictureSelector.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'

  s.source_files = 'PictureSelector/Classes/**/*'
  
  s.resource_bundles = {
    'PictureSelector' => ['PictureSelector/Assets/*.{xcassets}']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit','Photos','PhotosUI'
  s.dependency 'SnapKit'
  s.dependency 'SVProgressHUD'
end
