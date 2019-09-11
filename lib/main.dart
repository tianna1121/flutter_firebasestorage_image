import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() => runApp(MaterialApp(
      title: "Fashion",
      home: ImagesScreen(),
    ));

class ImagesScreen extends StatelessWidget {
  Widget makeImageGrid() {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (context, index) {
        return ImageGridItem(index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fashion"),
      ),
      body: Container(child: makeImageGrid()),
    );
  }
}

class ImageGridItem extends StatefulWidget {
  int _index;

  ImageGridItem(int index) {
    this._index = index;
  }
  @override
  _ImageGridItemState createState() => _ImageGridItemState();
}

class _ImageGridItemState extends State<ImageGridItem> {
  Uint8List imageFile;
  StorageReference storageReference =
      FirebaseStorage.instance.ref().child("photos");

  getImage() {
    int MAX_SIZE = 1 * 1024 * 1024;
    storageReference
        .child("fashion_${widget._index}.jpg")
        .getData(MAX_SIZE)
        .then((data) {
      setState(() {
        imageFile = data;
      });
    }).catchError((error) {
      print(error.toString());
    });
  }

  Widget decideGridTileWidget() {
    if (imageFile == null) {
      return Center(
        child: Text("No data"),
      );
    } else {
      return Image.memory(
        imageFile,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getImage();
  }

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: decideGridTileWidget(),
    );
  }
}
