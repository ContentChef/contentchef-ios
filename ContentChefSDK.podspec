Pod::Spec.new do |s|
  s.name             = "ContentChefSDK"
  s.version          = "1.0"
  s.summary          = "Content Chef SDK"
  s.homepage         = "https://github.com/ContentChef/contentchef-ios"
  s.license          = ""
  s.author           = { "Paolo Malpeli" => "p.malpeli@zest.one" }
  s.source           = { :git => "https://github.com/ContentChef/contentchef-ios.git", :tag => s.version }
  s.platform     = :ios, '11.4'
  s.requires_arc = true

  s.source_files = "ContentChefSDK/**/*.{h,m,swift}"

  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }
  s.swift_version = '5.0'

  s.module_name = 'ContentChefSDK'
end

