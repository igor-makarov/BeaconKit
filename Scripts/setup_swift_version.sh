#!/bin/bash
if [ "$SWIFTC_VERSION" != "" ]; then 
  if [ "$SWIFTC_VERSION" == "4" ]; then
    echo "$SWIFTC_VERSION.0" > .swift-version
  else
    echo "$SWIFTC_VERSION" > .swift-version
  fi
elif [ "$SWIFT_VERSION" != "" ]; then
  echo "$SWIFT_VERSION" > .swift-version
fi
