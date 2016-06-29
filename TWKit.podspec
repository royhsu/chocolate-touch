Pod::Spec.new do |spec|
  spec.name             = 'TWKit'
  spec.version          = '0.1'
  spec.license          = 'MIT'
  spec.homepage         = 'The more advanced framework built upon cocoa touch.'
  spec.authors          = { 'Tiny World' => 'roy.hsu@tinyworld.cc' }
  spec.summary          = 'A personalized foundation framework for Swift.'
  spec.source           = { :git => 'https://github.com/royhsu/chocolate-touch.git', :tag => spec.version }

  spec.ios.deployment_target = '8.0'

  spec.source_files     = 'Sources/*.swift'
  
  spec.dependency = 'TWFoundation'
end