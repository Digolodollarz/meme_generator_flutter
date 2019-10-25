import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

//import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';

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

  File _savedFile;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(8),
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
                              textScaleFactor:
                                  MediaQuery.of(context).textScaleFactor,
                            );
                            textPainter.layout(maxWidth: size.maxWidth);

                            var fontSize = textFieldTextStyle.fontSize;
                            int lines = (textPainter.size.height /
                                    textPainter.preferredLineHeight)
                                .ceil();

                            print('font: $fontSize, '
                                'lines $lines '
                                'textHeight: ${textPainter.height}, '
                                'dimensions: $dimensions, '
                                'systemScaleFactor: ${MediaQuery.of(context).textScaleFactor} '
                                'scaleFactor: ${textPainter.textScaleFactor}');
                            // not really efficient and doesn't find the perfect size,
                            // but gets the job done!
                            while (
                                textPainter.size.height >= (dimensions / 4)) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton.icon(
                  icon: Icon(Icons.save_alt),
                  label: Text('Save Image'),
                  onPressed: _capturePng,
                  color: Theme.of(context).primaryColor,
                ),
                RaisedButton.icon(
                  icon: Icon(Icons.share),
                  label: Text('Share'),
                  onPressed: _sharePng,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<Uint8List> _capturePng({bool save = true}) async {
    try {
      print('inside');
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
//      var bs64 = base64Encode(pngBytes);
//      print(pngBytes);
//      print(bs64);
//      setState(() {});
      if (!save) return pngBytes;
      var file = await _saveFile(pngBytes);
      if (file.existsSync()) {
        print('Saved');
      } else {
        print('Not Save');
      }
      return pngBytes;
    } catch (e) {
      print(e);
      return null;
    }
  }

  _sharePng() async {
    var bytes = await _capturePng(save: false);
    if (bytes == null) return;
    await Share.file(
        'Share meme', 'meme.png', bytes.buffer.asUint8List(), 'image/png');
  }

  Future<File> _saveFile(List<int> pngBytes) async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permission != PermissionStatus.granted) {
      var permissions = await PermissionHandler()
          .requestPermissions([PermissionGroup.storage]);
      permission = permissions[PermissionGroup.storage];
      if (permission != PermissionStatus.granted) {
        await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("No storage permissions"),
                content:
                    Text("You have not approved storage permissions, so the "
                        "image cannot be save to the gallery."),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel'),
                  )
                ],
              );
            });

        return null;
      }
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });

    final dir = await getExternalStorageDirectory();

    File file =
        File('${dir.path}/Meme/${DateTime.now().toIso8601String()}.png');
    if (!file.existsSync()) {
      file.createSync(recursive: true);
      if (file.existsSync())
        print('Done Create');
      else
        print('Ndakonewa');
    }
    file.writeAsBytesSync(pngBytes);
    print(file);
    if (file.existsSync()) {
      print('Saved');
    } else {
      print('Agh');
    }
    Navigator.of(context).pop();
    return file;
  }
}
