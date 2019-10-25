import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meme_generator/create/create_modern_widget.dart';
import 'package:meme_generator/models.dart';

import '../ads.dart';

class CreatePage extends StatefulWidget {
  final MemeImage image;

  const CreatePage({Key key, this.image}) : super(key: key);

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  var interstitialAd;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(title: Text(widget.image.title ?? 'New Meme')),
        body: CreateModernWidget(
          text: widget.image.title,
          image: widget.image.file,
        ),
      ),
      onWillPop: () async {
        if (await interstitialAd.isLoaded() && await interstitialAd.show())
          print('Ad Shown');
        return true;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _createIntertstial();
  }

  _createIntertstial() async {
    interstitialAd = InterstitialAd(
        adUnitId: Ads.interstitialAdId,
        listener: (MobileAdEvent event) {
          print("InterstitialAd event is $event");
          if (event == MobileAdEvent.closed) {
            interstitialAd.dispose();
          }
        });
    interstitialAd.load();
//    Ads.homeBanner?.dispose();
//    Ads.createBanner
//      ..load()
//      ..show();
  }

  @override
  void dispose() {
    try {
      interstitialAd?.dispose();
    } on Exception catch (e) {
      print('Exception $e');
    }
    super.dispose();
  }
}
