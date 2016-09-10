Pod::Spec.new do |s|
  s.name         = "XAutoLayout"
  s.version      = "2.0.0"
  s.summary      = "simplify writing AutoLayout in code. better direction handling."
  s.homepage     = "https://github.com/kaizeiyimi/XAutoLayout"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "kaizei" => "kaizeiyimi@126.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/kaizeiyimi/XAutoLayout.git", :tag => '2.0.0' }
  
  s.source_files  = "XAutoLayout/codes/**/*.swift"
end
