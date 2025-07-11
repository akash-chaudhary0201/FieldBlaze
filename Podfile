require_relative './mobile_sdk/SalesforceMobileSDK-iOS/mobilesdk_pods'

platform :ios, '17.0'

project 'FieldBlaze.xcodeproj'
target 'FieldBlaze' do
  source 'https://cdn.cocoapods.org/'
  use_frameworks!
  pod 'FSPagerView'
  pod 'MaterialComponents/TextControls+FilledTextAreas'
  pod 'MaterialComponents/TextControls+FilledTextFields'
  pod 'MaterialComponents/TextControls+OutlinedTextAreas'
  pod 'MaterialComponents/TextControls+OutlinedTextFields'
  pod 'DatePicker'
  pod 'SSDateTimePicker'
  pod 'DropDown'
  pod 'Toast-Swift', '~> 5.0.0'
  pod 'Alamofire'
  pod 'IQKeyboardManagerSwift'
  pod 'SideMenu'
  pod 'SDWebImage'
  use_mobile_sdk!
end

post_install do |installer|
  # Comment the following if you do not want the SDK to emit signpost events for instrumentation. Signposts are  enabled for non release version of the app.
  signposts_post_install(installer)

  mobile_sdk_post_install(installer)
end
