#!/bin/sh -l -x
(! (Pods/SwiftLint/swiftlint --reporter emoji 2> /dev/null | tee /dev/fd/2 | grep "⛔️" > /dev/null))
