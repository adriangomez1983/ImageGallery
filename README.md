## Gallery Images Upload


Please provide a gallery with an image upload feature.
This exercise is mostly front end with a tiny bit of back end.
If you're stronger on the backend, you can try this one, but we'll definitely be looking strength on the front end.
Please also ensure both the client and server side is *well tested* and *clean code* and that the code works before you submit your code.

### Client side

The client side can be either web or app.
If it's web, please ensure it can be used on multiple devices.
Completely up to you what frameworks you use; on our own code we use angular 2 or react for web, and all the usual libs for android and iOS that allows MVVM, MVP, and easier testing.

##### Web Requirements
* Provide a gallery view of all previously uploaded images
* For image Upload:
    * mobile web, tablet - this will be a button which will prompt you to either access the camera and take a pic, or select from files on device
    * desktop web - will have 2 options: drag image to page to upload, or a button which allows selection of multiple files on device
* super nice to see the web-views handling rotation on devices

##### App Requirements
For the image upload please provide:
 * a gallery view of all previously uploaded images
 * a button which can either request to take a picture, or upload from camera roll
 * the ability to rotate or crop images


### Server side
The server side can be in whatever language you are strong with.  
We mainly use js, java, and a little bit of php and go, so please try to use one of them that you're stronger with.

Don't worry too much about how this stuff should be stored and served properly on the server (such as s3 buckets, and CDNs etc).
It's fine to store and serve the images locally.

If you opt for a db approach, store in whatever storage you see fit.


## Implementation

#### Server
##### Stack
For the server implementation I've used:
   - Spring Boot 
   - Gradle 
   - Java
   - File system as storage
##### Service description
POST multipart
/files
uploads a single image and stores it in the file system

GET
/files
lists all of the stored files

GET
/files/{filename}.{extension}
gets the stored image with the given filename and extension

##### Error Handling and validations
There are no validations in the files names and also no check for repeated files
Very basic error handling

##### How to run the project
There are two options:
   - Intellij: go to imageupload folder and open the project from there.
   -- create a new run config by going to Run -> Edit Configurations... -> + -> select Spring Boot from the left panel -> set upload.Application as Main class and select imageupload_main as classpath
   -- The application should run by clicking the play icon
   - From command line: go to imageupload folder and excecute
```sh
$ ./gradlew build
$ ./gradlew bootRun
```

#### Client
The client is an iOS application that retireves the previously uploaded images listing them in the first screen and upon selecting any of the images listed, the listed images are displayed like a gallery in full size. The application also provide a way to upload images one by one from the device image library or from the camera if available. In addition the selected image can be rotated and/or cropped.

For the implementation I've followed MVP and used dependecy injection for easier testing.

#### Third-party libraries
I've used Alamofire for networking and AlamoImage for images loading

#### Testing
The main focus on the unit test was the behaviour of the presenters

To run the unit tests:
   - XCode is needed.
   - Go to ImageUploader folder and double-click ImageUploader.xcworkspace file
   - Press command+U or click and hold the play button and select the tool icon


##### How to run the client
   - XCode is needed.
   - Go to ImageUploader folder and double-click ImageUploader.xcworkspace file
   - Click the play button and the application should start
  
  
