# To avoid building swiftlint with the iOS SDK run:
# "/usr/bin/xcrun --sdk macosx"

# Then run the package Lint which installs and builds swiftlint:
# "swift run --package-path ./scripts/Lint"

# Afterwards run swiftlint, with a common config for the app:
# "swiftlint lint --strict --config ./.swiftlint.yml"

# Finally specify which files to lint:
# "./assignment"

# Expected only to be called from xcode, lints current app.
lintBuildPhase()
{
  /usr/bin/xcrun --sdk macosx swift run --package-path ./scripts/Lint swiftlint lint --strict --config ./.swiftlint.yml ./Kahoot
}

while [ "$1" != "" ]; do
    case $1 in
        -b | --build )      lintBuildPhase
                            ;;
        * )                 exit 1
    esac
    shift
done
