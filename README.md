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

:white_check_mark: Checking if an email exists here [app.kickbox.com](https://app.kickbox.com)

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

<details><summary> Sign In & Sign Up </summary><p>   

   ![SignIn](https://user-images.githubusercontent.com/69522563/199737570-284c89b3-dfb4-48e4-826f-467699235058.gif)
   ![SignUperrorsRegExample](https://user-images.githubusercontent.com/69522563/199737609-7ec9aabf-5726-4c66-931b-33fbf178d9b8.gif)
   </p></details>


<details><summary> Home Screen, Detail Post Screen & Create Post </summary><p>   

   ![home+detail](https://user-images.githubusercontent.com/69522563/199494042-caea057c-69c3-4a71-ab80-0639ed2370b9.gif)
   ![createPost](https://user-images.githubusercontent.com/69522563/199494076-74628721-eaf3-439e-ab14-251a07f6f191.gif)
  </p></details>


<details><summary> User Profile </summary><p>   

   ![Profile Settings](https://user-images.githubusercontent.com/69522563/200550024-7b3b8145-f83a-49a0-8ee9-4296e89fcb6a.gif)
   ![Dark mode, delete row, sign out](https://user-images.githubusercontent.com/69522563/200550036-af0c31b4-6e4e-45fe-9984-25a9b4eac3e9.gif)
  </p></details>



### Installation
___

1. Clone or download the project to your local machine
2. Install pod file in project. Pods are used: `FirebaseCore`, `FirebaseStorage`, `FirebaseFirestore`, `FirebaseAuth`, `ShimmerSwift`.
3. Replace  `apiKey`  with your valid app.kickbox.com key in `NetworkRequest.swift`
   ```swift
   class NetworkRequest {
   ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... 
   16       let urlString = "https://api.kickbox.com/v2/verify?email=\(varifableMail)&apikey=\(apiKey)"   
   ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... 
   }
   ```
4. You need to set up your own Firebase instance for the backend and copy this file to project `google-service.plist`.
5. Open the project in Xcode
6. Run the simulator

[:arrow_up:](#anchor)
