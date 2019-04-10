Pod::Spec.new do |s|
  s.name         = "XAutoLayout"
  s.version      = "3.2"
  s.summary      = "simplify writing AutoLayout in code. better direction handling."
  s.homepage     = "https://github.com/kaizeiyimi/XAutoLayout"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "kaizei" => "kaizeiyimi@126.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/kaizeiyimi/XAutoLayout.git", :tag => '3.2' }
  
  s.source_files  = "XAutoLayout/codes/**/*.swift"
  s.swift_version = "5.0"
end
