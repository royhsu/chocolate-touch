Pod::Spec.new do |spec|
  spec.name             = 'TWKit'
  spec.version          = '0.1'
  spec.license          = 'MIT'
  spec.homepage         = 'https://github.com/royhsu/chocolate-touch'
  spec.authors          = { 'Tiny World' => 'roy.hsu@tinyworld.cc' }
  spec.summary          = 'The more advanced framework built upon cocoa touch.'
  spec.source           = { :git => 'https://github.com/royhsu/chocolate-touch.git', :branch => master, :commit => 'HEAD' }

  spec.ios.deployment_target = '8.0'

  spec.source_files     = 'Sources/*.swift'
  
  spec.dependency 'TWFoundation', :git => 'https://github.com/royhsu/swift-foundation.git', :branch => 'master', :commit => 'e606361127550aaa7644c4e9bca7b75c9eb31152'
end