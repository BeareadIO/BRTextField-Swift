#
#  Be sure to run `pod spec lint BRTextField.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "BRTextField-Swift"
  s.version      = "0.0.2"
  s.summary      = "BRTextField is bearead custom textfield."
  s.description  = <<-DESC
                    Bearead Input TextField, display a underline & a float label.
                  DESC

  s.homepage     = "https://github.com/BeareadIO/BRTextField-Swift"
  s.license      = "MIT"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "UnicornBoss" => "archyvan9092@gmail.com" }
  s.platform     = :ios, "8.0"
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
  s.source       = { :git => "https://github.com/BeareadIO/BRTextField-Swift.git", :tag => "#{s.version}" }
  s.source_files  = "BRTextField/BRTextField.swift"
  # s.resource  = "icon.png"
  s.resource_bundle = {
  		'BRTextField' => ['BRTextField/BRTextField.bundle/*.png']
  }

end
