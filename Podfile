platform :ios, '12.0'
use_frameworks!

inhibit_all_warnings!

target 'JetDevsHomeWork' do
  pod 'RxSwift', '~> 5.1.0'
  pod 'SwiftLint'
  pod 'Kingfisher'
  pod 'SnapKit'
  pod 'Alamofire'
  pod 'RxAlamofire'
  pod 'RxCocoa'
  pod 'TPKeyboardAvoidingSwift'
  pod 'SkyFloatingLabelTextField'
  pod 'ProgressHUD'

  target 'JetDevsHomeWorkTests' do
    inherit! :search_paths
  end

  target 'JetDevsHomeWorkUITests' do
    inherit! :complete
  end  

  post_install do |installer|
    xcode_base_version = `xcodebuild -version | grep 'Xcode' | awk '{print $2}' | cut -d . -f 1`
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
        config.build_settings["ENABLE_BITCODE"] = "NO"
        config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
        # For xcode 15+ only
        if config.base_configuration_reference && Integer(xcode_base_version) >= 15
           xcconfig_path = config.base_configuration_reference.real_path
           xcconfig = File.read(xcconfig_path)
           xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
           File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
       end
      end
    end
  end
end

