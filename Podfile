# Uncomment the next line to define a global platform for your project
 platform :ios, '12.0'

target 'Locally' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Locally
pod 'AlamofireImage'
pod 'Moya'
pod 'Firebase/Core'
pod 'Firebase/Firestore'
pod 'Firebase/Functions'
pod 'Firebase/Storage'
pod 'Firebase/Auth'
pod 'ReachabilitySwift'
pod 'IQKeyboardManagerSwift'
pod 'lottie-ios' 
pod 'SwiftLint'
pod 'SDWebImage', '~> 5.0'
pod "SkeletonView"
pod 'SwiftMessages'
target 'LocallyTests' do
    inherit! :search_paths
    # Pods for testing
pod 'Firebase/Core'
  end

  target 'LocallyUITests' do
    inherit! :search_paths
    # Pods for testing
pod 'Firebase/Core'
  end

end
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            if config.name == 'Debug'
                config.build_settings['OTHER_SWIFT_FLAGS'] = ['$(inherited)', '-Onone']
                config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
            end
        end
    end
end
