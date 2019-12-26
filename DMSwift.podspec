Pod::Spec.new do |s|
  s.name         = "DMSwift"
  s.version      = "0.1"
  s.summary      = "A Download Manager"
  s.description  = <<-DESC
    Your description here.
  DESC
  s.homepage     = "https://github.com/sh-khashimov/DMSwift"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Sherzod Khashimov" => "sh.khashimov@gmail.com" }
  s.social_media_url   = ""
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"
  s.swift_versions = "5.0"
  s.source       = { :git => "https://github.com/sh-khashimov/DMSwift.git", :tag => s.version.to_s }
  s.source_files  = "Sources/**/*"
  s.frameworks  = "Foundation"
end
