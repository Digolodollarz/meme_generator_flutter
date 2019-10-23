import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:image/image.dart' as img;

class CreateModernWidget extends StatefulWidget {
  final String text;
  final File image;

  CreateModernWidget({Key key, this.text, this.image}) : super(key: key);

  @override
  _CreateModernWidgetState createState() => _CreateModernWidgetState();
}

class _CreateModernWidgetState extends State<CreateModernWidget> {
  String textValue;
  final TextEditingController _controller = TextEditingController();
  final GlobalKey _textFieldKey = GlobalKey();
  final GlobalKey _globalKey = GlobalKey();

  static const textFieldPadding = EdgeInsets.all(8.0);
  static const textFieldTextStyle = TextStyle(fontSize: 30.0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          children: [
            RepaintBoundary(
              key: _globalKey,
              child: LayoutBuilder(
                builder: (context, size) {
                  double dimensions = size.maxWidth > size.maxHeight
                      ? size.maxHeight
                      : size.maxWidth;
                  return SizedBox(
                    width: dimensions,
                    height: dimensions + 16,
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          LayoutBuilder(builder: (context, size) {
                            // calculate width of text using text painter
                            final textPainter = TextPainter(
                              textDirection: TextDirection.ltr,
                              text: TextSpan(
                                text: _controller.text,
                                style: textFieldTextStyle,
                              ),
                            );
                            textPainter.layout(maxWidth: size.maxWidth);

                            var fontSize = textFieldTextStyle.fontSize;
                            int lines = (textPainter.size.height /
                                    textPainter.preferredLineHeight)
                                .ceil();
                            print('lines $lines');

                            // not really efficient and doesn't find the perfect size,
                            // but gets the job done!
                            while (textPainter.size.height > (dimensions / 4)) {
                              fontSize -= 0.5;
                              textPainter.text = TextSpan(
                                text: _controller.text,
                                style: textFieldTextStyle.copyWith(
                                    fontSize: fontSize),
                              );
                              textPainter.layout(maxWidth: size.maxWidth);
                            }

                            return Container(
                              height: dimensions / 4 + 8,
                              child: TextField(
                                key: _textFieldKey,
                                controller: _controller,
                                maxLines: null,
                                style: textFieldTextStyle.copyWith(
                                  fontSize: fontSize,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                    hintText: 'Entero meme textero'),
                              ),
                            );
                          }),
                          AspectRatio(
                            child: Image.file(
                              widget.image,
                              fit: BoxFit.cover,
                            ),
                            aspectRatio: 4 / 3,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            RaisedButton(
              child: Text('Save Image'),
              onPressed: _capturePng,
            ),
          ],
        ),
      ),
    );
  }

  Future<Uint8List> _capturePng() async {
    try {
      print('inside');
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      print(pngBytes);
      print(bs64);
//      setState(() {});
      var file = await _saveFile(pngBytes);
      if (file.existsSync()) {
        print('Saved');
      } else {
        print('Not Save');
      }
      return pngBytes;
    } catch (e) {
      print(e);
    }
  }

  Future<File> _saveFile(List<int> pngBytes) async {
    final dir = await getExternalStorageDirectory();
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
      if (dir.existsSync())
        print('Done Create');
      else
        print('Ndakonewa');
    } else {
      print('Exists');
    }

    File file = File('${dir.path}/Meme/${DateTime.now().toIso8601String()}.png')
      ..writeAsBytesSync(pngBytes);
    print(file);
    if (file.existsSync()) {
      print('Exists');
    } else {
      print('Agh');
    }
    return file;
  }
}
