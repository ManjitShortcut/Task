# Kahoot Task

The app is created for a client named Glitre 
The app helps  Electric power consumer to view Invoice and consumption of power

## Glitre Energi Nett_MVP

* Login( ID porten)
* Invoice
* Consumption (Day, Month, Week, Year)
* Download Invoice Pdf.
* Power grid Alert 
* Report Error
* Notification (if any Grid failure on your  locality)

### Prerequisites
* Xcode 12.5 or above
* Pod
* Swiftlint
* >= iOS 13

### Building for the simulator
In order to run this app in your simulator, perform the following steps:
* Run `Pod install` in the root folder of the project.
* Open GlitreApp.xcodeproj
* Click build/run.

### Libraries or Packages used
* 'Alamofire', '~> 5.4' (For Network)
* 'AppAuth',            (Login for ID Porton)
* 'KeychainSwift', '~> 19.0' (Storing data device key chain)

### Design Pattern
* 'MVVM' + 'COORDINATOR'
* PushNotification Center

## Building prerelease versions
Distribution of pre-release versions is done using Test-flight in iTunes connect.

## Project Structure Info
* AppConfiguration file where base-end point Url, ApiKey, And idPorten login setup define.
* ApiEndUrl file where all end point has defined.
* Theme Where all used image, Local text and Font and Color define for the project
* No Storyboard and no Xib file

## Project Traget
* GlitreApp is used for app store
* GlitreApp_Dev is used for Development/Testing





