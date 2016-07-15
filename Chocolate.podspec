Pod::Spec.new do |spec|
  spec.name             = 'Chocolate'
  spec.version          = '0.3'
  spec.license          = 'MIT'
  spec.homepage         = 'https://github.com/royhsu/chocolate-touch'
  spec.authors          = { 'Tiny World' => 'roy.hsu@tinyworld.cc' }
  spec.summary          = 'The more advanced framework built upon cocoa touch.'
  spec.source           = { :git => 'https://github.com/royhsu/chocolate-touch.git', :tag => spec.version }
  spec.source_files     = 'Source/*.swift'
  spec.ios.deployment_target = '8.0'
  
  spec.dependency 'CHFoundation', '0.3' 
end