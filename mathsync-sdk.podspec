Pod::Spec.new do |s|
  s.name         = "mathsync-sdk"
  s.version      = "0.1.0"
  s.summary      = "3musket33rs mathematical synchronization library."
  s.homepage     = "https://github.com/3musket33rs/mathsync-ios"
  s.license      = 'Apache License, Version 2.0'
  s.author       = "Red Hat, Inc."
  s.source       = { :git => 'https://github.com/3musket33rs/mathsync-ios.git' }
  s.platform     = :ios, 7.0
  s.source_files = 'mathsync-sdk/**/*.{h,m}'
  s.public_header_files = 'mathsync-sdk/MKMathSyncSdk.h', 'mathsync-sdk/MKSerializer.h', 'mathsync-sdk/MKDeserializer.h', 'mathsync-sdk/MKSummarizer.h', 'mathsync-sdk/MKSummarizerFromItems.h', 'mathsync-sdk/MKSummarizerFromJson.h', 'mathsync-sdk/MKResolver.h', 'mathsync-sdk/MKResolverFromSummarizers.h'
  s.requires_arc = true
end
