#
# Be sure to run `pod lib lint AIMQuestionnaire.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AIMQuestionnaire'
  s.version          = '0.1.3'
  s.summary          = 'AIMQuestionnaire support the generate of question and answer. support theme. require AIMJSONModelNetworking-iOS for JSON and Model parse'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'AIMQuestionnaire support the generate of question and answer. support theme. require AIMJSONModelNetworking-iOS for JSON and Model parse. the result will be delegate back and you can freely manage it.'

  s.homepage         = 'https://github.com/Ponlavit/AIMQuestionnaire'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ponlavit Larpeampaisarl' => 'ponlavit@do.in.th' }
  s.source           = { :git => 'https://github.com/Ponlavit/AIMQuestionnaire.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/code_rabbit'

  s.ios.deployment_target = '9.0'
  s.module_name = 'AIMQuestionnaire'
  s.source_files = 'AIMQuestionnaire/Classes/**/*'
  
  # s.resource_bundles = {
  #   'AIMQuestionnaire' => ['AIMQuestionnaire/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.requires_arc     = true
  s.dependency 'AIMJSONModelNetworking-iOS'
  s.dependency 'MBProgressHUD'
end
