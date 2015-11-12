platform :ios, '7.0'
source 'https://github.com/CocoaPods/Specs.git'

# Add Application pods here
pod 'AFNetworking'

target :unit_tests, :exclusive => true do
  link_with 'UnitTests'
  pod 'Specta',     :git=>'git@github.com:specta/specta.git'
  pod 'Expecta'
  pod 'OCMockito'
  pod 'Swizzlean'
  pod 'OHHTTPStubs'
  pod 'KIF'
end
