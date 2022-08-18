# project-base

Use "sh ./scripts/swiftgen.sh" to generate helper files (like lokalistaion colors and app assets)

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
* AppConfiguration file where base-end point Url.
* No Storyboard and no Xib file

## Project Traget
* Kahoot is used for app store

## Project Structure
* Networking : Only Dependancy new-work  in this folder
* Kahoot Kit : All Reuse-able component in Kahoot kit folder
* Kahoot : All feature should be in Kahoot folder
  
## New Feature
 If a new feature is added then follow this folder structure
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
* ShadowCollectionViewItem: It is parent class for Choice view cell. Shadow already added here. 
  If you modified the shadow then respective child class will affected.

## File Structure
* Property: All public property in a class at the top follow by private property, then all ui element
* All public method should be on the top with group by #pargma mark Public method then by private methods group by #pargma mark private method

##NB: Remember add child coordinator to parent coordinator array and also remove child coordinator when pop/dismissed the view

