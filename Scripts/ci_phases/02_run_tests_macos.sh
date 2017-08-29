#!/bin/sh -l +o xtrace
set -o pipefail && \
xcodebuild test \
    -workspace BeaconKit.xcworkspace \
    -scheme BeaconKitTests-macOS \
    -configuration Debug \
    CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY= PROVISIONING_PROFILE= \
| tee build/tests_macos.txt \
| xcpretty
