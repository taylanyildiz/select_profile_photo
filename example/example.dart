import 'dart:io';
import 'package:flutter/material.dart';
import 'package:select_profile_photo/select_profile_photo.dart';

void main() {
  runApp(MyApp());
}

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
                          ))),
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
