#!/bin/bash
if [ "$LINT" != "" ]; then 
  echo "Linting project..."
  Scripts/ci_phases/01_lint_project.sh
fi
if [ "$SWIFT_VERSION" != "" ]; then 
  echo "Running tests on macOS using Xcode..."
  Scripts/ci_phases/02_run_tests_macos.sh
fi
if [ "$SWIFT_VERSION" != "" ]; then 
  echo "Running tests on iOS using Xcode..."
  travis_retry Scripts/ci_phases/03_run_tests_ios.sh
fi
if [ "$SWIFTC_VERSION" != "" ]; then 
  echo "Running tests on macOS using Swift-PM..."
  swift test -Xswiftc '-DDEBUG' -Xswiftc -swift-version -Xswiftc $SWIFTC_VERSION 
fi
