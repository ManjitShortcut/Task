# Lint

SwiftLint is required to lint the project, to avoid version conflicts between developers, this package ensures the same version is always used.

Package was initialized with:
- `swift package init` - Package will be created with the current directory name. 

Note package will be created with folders for tests and sources. Just having an empty source file is enough, so modify accordingly depending on what is needed.
- `swift run Lint` will generate the .build resources. 
- However refer to the `Build Phase`s in Spare and Mobilbank (App-Prebuild). 
- See the phase `Run Swiftlint`.
