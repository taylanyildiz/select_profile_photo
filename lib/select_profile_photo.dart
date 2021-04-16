import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:select_profile_photo/utils_image.dart';

class ImagePicker extends StatefulWidget {
  final String title;
  String selectTitle;
  String takeTitle;
  String deleteTitle;
  IconData iconImage;
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
  bool showTitle;
  final int itemCount;
  final Function(List<File>) selectionPhoto;
  AndroidUiSettings androidUiSettingsLock;
  IOSUiSettings iosUiSettings;
  ImagePicker({
    Key key,
    @required this.selectionPhoto,
    this.title,
    this.takeTitle = 'Take a Photo',
    this.selectTitle = 'Select a Photo',
    this.deleteTitle = 'Delete Photo',
    this.showTitle = true,
    IconData iconImage,
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
        iconImage = iconImage ?? Icons.image,
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

class _ImagePickerState extends State<ImagePicker> {
  final imageFiles = <File>[];
  bool isGallery = false;
  Future selectPhoto(index) async {
    final file = await UtilsImage.mediaPicker(
      isGallery: isGallery,
      croppImage: croppImage,
    );
    if (file == null) return;
    if (imageFiles.length >= index) {
      imageFiles.removeAt(index - 1);
      setState(() => imageFiles.insert(index - 1, file));
    } else
      setState(() => imageFiles.add(file));
    widget.selectionPhoto(imageFiles);
  }

  Future<File> croppImage(File file) async => await ImageCropper.cropImage(
        sourcePath: file.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        maxHeight: 100,
        maxWidth: 100,
        compressFormat: ImageCompressFormat.png,
        androidUiSettings: widget.androidUiSettingsLock,
        iosUiSettings: widget.iosUiSettings,
      );

  Future<List<Widget>> dispLayWidget() async {
    final displaylist = <Widget>[];
    Widget child;
    bool checkImage = false;
    for (var index = 1; index <= widget.itemCount; index++) {
      if (imageFiles.length >= index) {
        checkImage = true;
        child = ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Image.file(
            imageFiles[index - 1],
            fit: BoxFit.cover,
          ),
        );
      } else {
        checkImage = false;
        child = Icon(
          widget.iconImage,
          color: widget.iconColor,
          size: 35.0,
        );
      }
      displaylist.add(
        Stack(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                color: widget.backgroundImage,
                borderRadius: BorderRadius.circular(checkImage ? 15.0 : 0.0),
              ),
              child: child,
            ),
            Positioned(
              right: 0.0,
              bottom: 0.0,
              child: GestureDetector(
                onTap: () async {
                  await showCupertinoModalPopup(
                    context: context,
                    builder: (context) => CupertinoActionSheet(
                      actions: [
                        CupertinoActionSheetAction(
                          isDefaultAction: true,
                          child: Text(widget.selectTitle),
                          onPressed: () {
                            isGallery = true;

                            Navigator.pop(context);
                            selectPhoto(index);
                          },
                        ),
                        CupertinoActionSheetAction(
                          isDestructiveAction: true,
                          child: Text(widget.takeTitle),
                          onPressed: () {
                            isGallery = false;
                            Navigator.pop(context);
                            selectPhoto(index);
                          },
                        ),
                        CupertinoActionSheetAction(
                          isDefaultAction: false,
                          child: Text(widget.deleteTitle),
                          onPressed: () {
                            Navigator.pop(context);
                            if (imageFiles.length >= index) {
                              setState(() {
                                imageFiles.removeAt(index - 1);
                              });
                            }
                            widget.selectionPhoto(imageFiles);
                          },
                        )
                      ],
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: widget.buttonColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    checkImage ? widget.iconEdit : widget.iconAdd,
                    color:
                        checkImage ? widget.iconEditColor : widget.iconAddColor,
                    size: 20.0,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }
    return displaylist;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: widget.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.showTitle != false
              ? Container(
                  margin: EdgeInsets.all(20.0),
                  child: widget.title != null
                      ? Text(
                          widget.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : SizedBox.shrink(),
                )
              : SizedBox.shrink(),
          FutureBuilder<List<Widget>>(
            future: dispLayWidget(),
            builder: (context, constraint) {
              if (constraint.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Wrap(
                    spacing: 10.0,
                    direction: Axis.horizontal,
                    children: constraint.data,
                  ),
                );
              } else {
                return Text('Error');
              }
            },
          ),
        ],
      ),
    );
  }
}
