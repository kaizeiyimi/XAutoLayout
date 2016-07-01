Pod::Spec.new do |s|
  s.name         = "XAutoLayout"
  s.version      = "1.2.3"
  s.summary      = "simplify writing AutoLayout in code. better direction handling. need swift 2.2"
  s.homepage     = "https://github.com/kaizeiyimi/XAutoLayout"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "kaizei" => "kaizeiyimi@126.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/kaizeiyimi/XAutoLayout.git", :tag => '1.2.3' }
  
  s.source_files  = "XAutoLayout/codes/**/*.swift"
  s.requires_arc = true
end
