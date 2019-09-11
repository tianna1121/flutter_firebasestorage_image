import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

import './dataHolder.dart';

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
        return ImageGridItem(index + 1);
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
    if (!requestedIndexes.contains(widget._index)) {
      int MAX_SIZE = 1 * 1024 * 1024;
      storageReference
          .child("fashion_${widget._index}.jpg")
          .getData(MAX_SIZE)
          .then((data) {
        setState(() {
          imageFile = data;
        });
        imageData.putIfAbsent(widget._index, () {
          return data;
        });
      }).catchError((error) {
        print(error.toString());
      });
      requestedIndexes.add(widget._index);
    }
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
    if (!imageData.containsKey(widget._index)) {
      getImage();
    } else {
      setState(() {
        imageFile = imageData[widget._index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: decideGridTileWidget(),
    );
  }
}
