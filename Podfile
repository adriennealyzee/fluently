# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'


target 'Fluently' do
  # Comment the next line if you don't want to use dynamic frameworks
  # use_frameworks!

  # Pods for keyboard
  pod 'Firebase/Analytics', '7.2-M1'
  pod 'GoogleMLKit/Translate'
   

end

target 'keyboard' do
  # Comment the next line if you don't want to use dynamic frameworks
  # use_frameworks!

  # Pods for keyboard
  pod 'Firebase/Analytics', '7.2-M1'
  pod 'GoogleMLKit/Translate'
	 

end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end

