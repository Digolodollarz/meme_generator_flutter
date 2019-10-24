import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

import '../models.dart';
import 'create_page.dart';

class BrowseWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('templates').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return Text('Error ${snapshot.error}');
              if (snapshot.connectionState == ConnectionState.waiting)
                return Text('Loading');
              return Center(
                child: ListView(
                  children: snapshot.data.documents
                      .map((DocumentSnapshot document) {
                    final url = document['image_url'];
                    final title = document['title'];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                title,
                                style: Theme.of(context)
                                    .textTheme
                                    .display1
                                    .copyWith(color: Colors.black),
                              ),
                              AspectRatio(
                                aspectRatio: 16 / 10,
                                child: CachedNetworkImage(
                                  imageUrl: url,
                                  placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator()),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () async {
                          File file = await saveAndLoadImage(url, title);
                          if (file != null) {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              var image = MemeImage();
                              image.title = "A modern type of meme";
                              image.file = file;
                              return CreatePage(
                                image: image,
                              );
                            }));
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              );
            }),
      ),
    );
  }
}

Future<File> saveAndLoadImage(String url, String title) async {
  var documentsDirectory = await getApplicationDocumentsDirectory();
  var extension = url.split('.')..last;
  File file = File('${documentsDirectory.path}/templates/$title/.$extension');
  if (!file.existsSync())
    file.createSync(recursive: true);
  else if (file.lengthSync() > 0) return file;
  var imageResponse = await http.get(url);
  file.writeAsBytesSync(imageResponse.bodyBytes);
  if (file.existsSync())
    print('Nkomo did it');
  else
    print("Nkomo can't did it");
  return file;
}

Future<File> pickImage() async {
  return await ImagePicker.pickImage(source: ImageSource.gallery);
}

class TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Modern Meme Generator',
            style: Theme.of(context).textTheme.display1.copyWith(fontSize: 18),
          ),
          Icon(Icons.menu),
        ],
      ),
    );
  }
}
