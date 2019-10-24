import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meme_generator/create/create_modern_widget.dart';
import 'package:meme_generator/models.dart';

class CreatePage extends StatefulWidget {
  final MemeImage image;

  const CreatePage({Key key, this.image}) : super(key: key);

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(title: Text("Unsettled Tom")),
        body: CreateModernWidget(
          text: widget.image.title,
          image: widget.image.file,
        ),
      ),
      onWillPop: () {},
    );
  }
}
