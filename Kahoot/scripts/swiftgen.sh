#!/bin/bash

if which swiftgen >/dev/null && swiftgen --version | grep -q 'v6.5.1' ; then
    : # NO-OP
else
    echo "warning: SwiftGen 6.5.1 is not installed, download from https://github.com/SwiftGen/SwiftGen"
    exit 1
fi

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
APP_ROOT="$(dirname "$SCRIPTPATH")/Kahoot"

# Run swiftgen for Project

swiftgen run xcassets \
$APP_ROOT/Resources/Images.xcassets \
--template swift4 \
--output $APP_ROOT/Resources/Generated/XCAssets+Generated.swift \
--param forceProvidesNamespaces \
--param publicAccess \
--param enumName=Asset


swiftgen run xcassets \
$APP_ROOT/Resources/Colors.xcassets \
--template swift4 \
--output $APP_ROOT/Resources/Generated/XCColors+Generated.swift \
--param forceProvidesNamespaces \
--param publicAccess \
--param enumName=Color



