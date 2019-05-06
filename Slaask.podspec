Pod::Spec.new do |s|
  s.name             = 'Slaask'
  s.version          = '0.1.1'
  s.summary          = 'The customer service app for all Slack users.'
  s.description      = <<-DESC
Slaask supercharges your Slack to function as a real-time customer service app shared among your team.

With Slaask, you can interact with your leads and customers wherever they are on the web from a single point in space: Slack!
                       DESC

  s.homepage         = 'https://github.com/slaaskhq/ios-sdk'
  s.screenshots      = 'https://s3.amazonaws.com/assets.slaask.com/ios-sdk-1.png'
  s.license          = { type: 'MIT', file: 'LICENSE' }
  s.author           = { 'Slaask' => 'contact@slaask.com' }
  s.source           = { git: 'https://github.com/slaaskhq/ios-sdk.git', tag: s.version.to_s }
  s.social_media_url = 'https://twitter.com/slaaskhq'
  s.swift_version    = '4.0'

  s.ios.deployment_target = '9.0'

  s.source_files = 'Slaask/Classes/**/*'
end
