Pod::Spec.new do |s|
  s.name         = "TWKit"
  s.version      = "0.0.1"
  s.summary      = "A short description of TWKit."
  s.description  = "The more advanced framework built upon cocoa touch."
  s.homepage     = "https://github.com/royhsu/chocolate-touch"
  s.license      = "MIT"
  s.author       = { "Tiny World" => "roy.hsu@tinyworld.cc" }

  s.ios.deployment_target = "8.0"

  s.source       = { :git => "https://github.com/royhsu/chocolate-touch.git", :head }
  s.source_files  = "Sources/*.swift"

  s.dependency "TWFoundation", :git => "https://github.com/royhsu/swift-foundation.git", :head
end
