# Task

### Prerequisites
* Xcode 13.4 or above
* Package
* Swiftlint
* SwiftGen
* >= iOS 14

### Building for the simulator
In order to run this app in your simulator, perform the following steps:
* Open Kahoot.xcodeproj
* Click build/run.

### Libraries or Packages used
* 'Kingfisher', '~> 7.0.0' (For downloading image)

### Design Pattern
* 'MVVM' + 'COORDINATOR'


## Project Structure Info
* AppConfiguration file where base-end point Url, ApiKey.
* No Storyboard and no Xib file

## Project Traget
* Kahoot is used for app store
* Kahoot_Test is used for Development/Testing

## Project Structure
* Networking : Only Dependancy new-work  in this folder
* Kahoot Kit : All Reuse-able component in Kahoot kit folder
* Kahoot : All feature should be in Kahoot folder
  
## New Feature
 If a new feature is added then follow this folder structere
Ex- Quiz
 Then folder structure will be 
 
* Quiz As parent folder 
* ViewController
* ViewModel
* Api
* Coordinator
* Model

### Reusable Class
* Shadow Button: Which is responsible for all default shadow button
* Lable: It the subclass of UILable.
* ShadowCollectionViewItem: It is pare nt calss for Choice view cell. Shadow alreday added here. 
  If you modified the shadoe then respective child class will affected.

### NB:
Follow docC for documentation 
