# BloggingMe

<a id="anchor"></a>



You can share and delete your posts, view the posts of all users of the application and share your favorite photos.

Firebase Firestore  is used to store information about the users and their posts. Firebase Storage to  is used to store user profile pictures and post header images.

:white_check_mark: The application supports registration and logging out of the account using mail and password.

:white_check_mark: You can change your account name or profile picture.

:white_check_mark: Custom TabBar, Navigation Buttons, Fonts, Colors.

:white_check_mark: Vibrate for selection.

:white_check_mark: Shimmer for App Name.

:white_check_mark: Reducing the size of the picture when the keyboard appears and vice versa

:white_check_mark: Dark mode supported. 

:heavy_minus_sign: Checking if an email exists not supported yet

+ UIKit
+ UITableView
+ UIImagePickerController
+ UITapGestureRecognizer
+ UIMenu
+ UIStackView
+ CocoaPods
+ UserDefaults
+ URLSession
+ Auto Layout


### Screen Recording

___
![signInError](https://user-images.githubusercontent.com/69522563/199493974-98570596-86c5-48ea-9691-6f8f6dd0d69e.gif)
![SignUPVC](https://user-images.githubusercontent.com/69522563/199494014-6809d655-41d4-4fdf-ae82-e970067767a4.png)

![home+detail](https://user-images.githubusercontent.com/69522563/199494042-caea057c-69c3-4a71-ab80-0639ed2370b9.gif)
![createPost](https://user-images.githubusercontent.com/69522563/199494076-74628721-eaf3-439e-ab14-251a07f6f191.gif)

![Profile](https://user-images.githubusercontent.com/69522563/199494090-a441870e-8738-4e36-86a6-86d0c5e4d83f.gif)


### Installation

___

1. Clone or download the project to your local machine
2. Install pod file in project. Pods are used: `FirebaseCore`, `FirebaseStorage`, `FirebaseFirestore`, `FirebaseAuth`, `ShimmerSwift`.
3. You need to set up your own Firebase instance for the backend and copy this file to project `google-service.plist`.
4. Open the project in Xcode
4. Run the simulator

[:arrow_up:](#anchor)
