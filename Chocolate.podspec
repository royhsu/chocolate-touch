Pod::Spec.new do |spec|
  spec.name             = 'Chocolate'
  spec.version          = '0.1'
  spec.license          = 'MIT'
  spec.homepage         = 'https://github.com/royhsu/chocolate-touch'
  spec.authors          = { 'Tiny World' => 'roy.hsu@tinyworld.cc' }
  spec.summary          = 'The more advanced framework built upon cocoa touch.'
  spec.source           = { :git => 'https://github.com/royhsu/chocolate-touch.git', :tag => spec.version }

  spec.ios.deployment_target = '8.0'

  spec.source_files     = 'Sources/*.swift'
end