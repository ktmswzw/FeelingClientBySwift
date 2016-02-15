source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!
#json格式处理
pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git'
#网络
pod 'Alamofire', :git => 'https://github.com/Alamofire/Alamofire'
#form快速架构
pod 'Eureka', :git => 'https://github.com/xmartlabs/Eureka'
#json对象映射
pod 'ObjectMapper', :git => 'https://github.com/Hearst-DD/ObjectMapper'
#加密类
pod 'CryptoSwift', :git => 'https://github.com/krzyzanowskim/CryptoSwift'
#jwt加密传输
pod 'JSONWebToken', :git => 'https://github.com/kylef/JSONWebToken.swift'
#动态效果框架
pod 'IBAnimatable', :git => 'https://github.com/JakeLin/IBAnimatable'
#照片提起
pod 'ImagePickerSheetController', :git => 'https://github.com/larcus94/ImagePickerSheetController.git'
#字体特效
pod 'LTMorphingLabel', :git => 'https://github.com/lexrus/LTMorphingLabel.git'
#sqlist数据库操作
pod 'SQLite.swift', :git => 'https://github.com/stephencelis/SQLite.swift.git'
#吐司
pod 'Whisper', :git => 'https://github.com/hyperoslo/Whisper'
#表单
#pod 'Former', :git => 'https://github.com/ra1028/Former'

post_install do |installer|
    installer.pods_project.build_configuration_list.build_configurations.each do |configuration|
        configuration.build_settings['CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES'] = 'YES'
    end
end