plugins {
    id "org.openbakery.xcode-plugin" version "0.11.4"
}
apply plugin: 'org.openbakery.xcode-plugin'
xcodebuild {
    version = "8"
     workspace = 'Yabbit.xcworkspace'
    target = 'Yabbit'
    scheme = 'Yabbit'
}