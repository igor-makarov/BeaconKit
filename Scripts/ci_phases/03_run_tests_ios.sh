#!/bin/sh -l +o xtrace
set -o pipefail && \
xcodebuild test \
    -workspace BeaconKit.xcworkspace \
    -scheme BeaconKitTests-iOS \
    -configuration Debug \
    -destination 'platform=iOS Simulator,name=iPhone 7,OS=latest' \
    CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY= PROVISIONING_PROFILE= \
| xcpretty