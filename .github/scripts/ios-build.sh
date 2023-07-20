#!/bin/bash

set -eo pipefail
cd ios

# build with SwiftPM:
# https://developer.apple.com/documentation/swift_packages/building_swift_packages_or_apps_that_use_them_in_continuous_integration_workflows

xcodebuild -workspace Runner.xcworkspace \
	-scheme Runner \
 	-destination "platform=iOS Simulator,name=iPhone SE (2nd generation)" \
	clean \
	build | xcpretty
