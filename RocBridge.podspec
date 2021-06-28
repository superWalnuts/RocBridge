
Pod::Spec.new do |s|
    s.name             = 'RocBridge'
    s.version          = '0.0.3'
    s.summary          = 'A bridge between JS and OC'
  
    s.description      = <<-DESC 
        A bridge between JS and OC,The bridge is very convenient.
      DESC
  
    s.homepage         = 'https://github.com/superWalnuts/RocBridge'
    s.license          = { :type => 'Apache', :file => './LICENSE' }
    s.author           = { 'DaPeng' => 'https://github.com/superWalnuts' }
    s.source           = { :git => 'https://github.com/superWalnuts/RocBridge.git', :tag => s.version.to_s }
  
    s.ios.deployment_target = '8.0'
  
    s.exclude_files = 'RocBridge-iOS/RocBridge/Info.plist'
    s.source_files = 'RocBridge-iOS/RocBridge/Classes/**/*.{h,m,mm,c}','RocBridge-iOS/RocBridge/RocBridge.h'
    s.ios.frameworks = ['JavaScriptCore', 'UIKit']     
  end
  