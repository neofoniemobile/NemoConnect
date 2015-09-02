Pod::Spec.new do |s|
  s.name         = 'NemoConnect'
  s.version      = '1.0.2'
  s.summary      = 'A declarative networking framework that allows networking calls with minimal code.'
  s.homepage     = 'http://www.neofonie-mobile.de/'
  s.social_media_url = 'https://twitter.com/neofoniemobile'
  s.license      = { :type => 'MIT', :file => 'LICENSE.txt' }
  s.authors      = { 'Neofonie Mobile GmbH' => 'contact@neofonie.de' }
  s.source       = { :git => 'https://github.com/neofoniemobile/NemoConnect.git',
                     :tag => s.version.to_s }

  s.ios.deployment_target = '7.1'
  s.osx.deployment_target = '10.8'

  s.source_files = 'Nemo\ Connect/Sources/**/*.{h,m}'
end
