# select_profile_photo

Image picker  & image cropper and cupertinosheet


## Screenshots

<img src="https://user-images.githubusercontent.com/37551474/114921008-bfe5e480-9e32-11eb-9302-cc85dac926ae.png" height="300em" /> <img src="https://user-images.githubusercontent.com/37551474/114921447-3be02c80-9e33-11eb-8a48-e7d50cd5647d.png" height="300em" /> <img src="https://user-images.githubusercontent.com/37551474/114921519-50bcc000-9e33-11eb-9b3e-f18b3644df3d.png" height="300em" /> <img src="https://user-images.githubusercontent.com/37551474/114921635-734ed900-9e33-11eb-93d5-ea739df05293.png" height="300em" />


## Usage

[Example](https://github.com/taylanyildiz/select_profile_photo/blob/main/example/example.dart)

To use this package :

* add the dependency to your [pubspec.yaml](https://github.com/taylanyildiz/select_profile_photo/blob/main/pubspec.yaml) file.

## dependencies:

```yaml
  dependencies:
    flutter:
      sdk: flutter
    image_picker: "last version"
    image_cropper: "last verison"
    select_profile_photo: "^0.1.7"
```

## How to use

## import

```dart
import 'package:select_profile_photo/select_profile_photo.dart';
```



## example


```dart
   ImagePicker(
    showTitle: false,
    title: 'Flutter Select Photo',
    itemCount: 4,
    height: 120.0,
    backgroundColor: Colors.white,
    backgroundImage: Colors.orange,
    iconColor: Colors.white,
    iconEditColor: Colors.red,
    iconAddColor: Colors.white,
    selectionPhoto: (file) {
      imagesFile = file;
    },
  ),
```

```dart
 class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Image Pickker and Image Cropper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var imagesFile = <File>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImagePicker(
            title: 'Flutter Select Photo',
            itemCount: 4,
            height: 120.0,
            backgroundColor: Colors.white,
            backgroundImage: Colors.orange,
            iconColor: Colors.white,
            iconEditColor: Colors.red,
            iconAddColor: Colors.white,
            selectionPhoto: (file) {
              imagesFile = file;
            },
          ),
          SizedBox(height: 20.0),
          SizedBox(
            width: 200.0,
            child: MaterialButton(
              color: Colors.red,
              textColor: Colors.white,
              child: Text(
                'Next Page',
                style: TextStyle(color: Colors.white, fontSize: 17.0),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PofileScreen(
                    imageFile: imagesFile,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Other page, display photos

class PofileScreen extends StatefulWidget {
  final List<File> imageFile;

  const PofileScreen({
    Key key,
    this.imageFile,
  }) : super(key: key);

  @override
  _PofileScreenState createState() => _PofileScreenState();
}

class _PofileScreenState extends State<PofileScreen> {
  PageController controller;
  _displayPhoto(index) {
    return Image.file(
      widget.imageFile[index],
      fit: BoxFit.cover,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Colors.red,
              height: 250,
              width: 300,
              child: PageView.builder(
                controller: controller,
                itemCount: widget.imageFile.length,
                itemBuilder: (context, index) => _displayPhoto(index),
              ),
            )
          ],
        ),
      ),
    );
  }
}
```
### UtilsImage Class
```dart
 import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class UtilsImage {
  static Future<File> mediaPicker({
    @required bool isGallery,
    @required Function(File file) croppImage,
  }) async {
    final source = isGallery ? ImageSource.gallery : ImageSource.camera;
    final pickerImage = await ImagePicker().getImage(source: source);
    if (pickerImage == null) return null;
    if (croppImage == null)
      return File(pickerImage.path);
    else
      return croppImage(File(pickerImage.path));
  }
}
```

### ImagePicker class
```dart
class ImagePicker extends StatefulWidget {
  final String title;
  IconData iconAdd;
  IconData iconEdit;
  Color backgroundColor;
  Color backgroundImage;
  Color buttonColor;
  Color iconColor;
  Color iconAddColor;
  Color iconEditColor;
  double height;
  double width;
  final int itemCount;
  final Function(List<File>) selectionPhoto;
  AndroidUiSettings androidUiSettingsLock;
  IOSUiSettings iosUiSettings;
  ImagePicker({
    Key key,
    @required this.selectionPhoto,
    this.title,
    IconData iconAdd,
    IconData iconEdit,
    Color backgroundImage,
    Color backgroundColor,
    Color buttonColor,
    Color iconColor,
    Color iconAddColor,
    Color iconEditColor,
    double height,
    double width,
    this.itemCount,
    AndroidUiSettings androidUiSettingsLock,
    IOSUiSettings iosUiSettings,
  })  : backgroundColor = backgroundColor ?? Colors.black,
        backgroundImage = backgroundImage ?? Colors.white,
        buttonColor = buttonColor ?? Colors.blue,
        iconColor = iconColor ?? Colors.white,
        iconAddColor = iconAddColor ?? Colors.white,
        iconEditColor = iconEditColor ?? Colors.red,
        iconAdd = iconAdd ?? Icons.add,
        iconEdit = iconEdit ?? Icons.edit,
        height = height ?? 200.0,
        width = width ?? 100.0,
        androidUiSettingsLock = androidUiSettingsLock ??
            AndroidUiSettings(
              lockAspectRatio: false,
              toolbarTitle: 'Image Cropper',
              toolbarColor: Colors.orange,
              toolbarWidgetColor: Colors.white,
              activeControlsWidgetColor: Colors.white,
              hideBottomControls: true,
            ),
        iosUiSettings = iosUiSettings ??
            IOSUiSettings(
              minimumAspectRatio: 1.0,
            ),
        assert(itemCount >= 3),
        super(key: key);

  @override
  _ImagePickerState createState() => _ImagePickerState();
}
```
### Android  path => android/app/src/main/AndroidManifest.xml
 

```activity
   <activity
      android:name="com.yalantis.ucrop.UCropActivity"
      android:screenOrientation="portrait"
      android:theme="@style/Theme.AppCompat.Light.NoActionBar"/>
```

### IOS   path => ios/Runner/Info.plist

```keys
    <key>NSCameraUsageDescription</key>
    <string>Explanation on why the camera access is needed.</string>	
    <key>NSPhotoLibraryUsageDescription</key>
    <string>Privacy - Photo Library Usage Description</string>	
    <key>NSMicrophoneUsageDescription</key>
    <string>Privacy - Microphone Usage Description</string>
```

## Getting Started

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
