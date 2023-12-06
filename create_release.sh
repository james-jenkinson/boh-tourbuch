#!/bin/bash
set -e

# get buildNumber/buildCounter
gitcount=`git log | grep "^commit" | wc -l | xargs`

# build app
echo "Using version $gitcount"
flutter build apk --split-per-abi --build-number "$gitcount"

