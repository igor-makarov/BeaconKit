#!/bin/sh -l -x
set +o pipefail # ugh, this kept linter from reporting fails
! (swiftlint --reporter emoji 2> /dev/null | tee /dev/fd/2 | grep "⛔️" > /dev/null)
