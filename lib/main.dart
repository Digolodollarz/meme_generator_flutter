import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:meme_generator/create/browse_widget.dart';
import 'package:meme_generator/create/create_modern_widget.dart';
import 'package:meme_generator/create/create_page.dart';
import 'package:meme_generator/create/create_widget.dart';
import 'package:meme_generator/history/history_widget.dart';
import 'package:meme_generator/models.dart';
import 'package:meme_generator/theme.dart';

import 'ads.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver analyticsObserver =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: getAppTheme(),
      home: MyHomePage(
        title: 'Modern MeMe Generator',
        analytics: analytics,
        observer: analyticsObserver,
      ),
      navigatorObservers: <NavigatorObserver>[analyticsObserver],
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.analytics, this.observer})
      : super(key: key);
  final String title;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _MyHomePageState createState() => _MyHomePageState(observer, analytics);
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;
  int _selectedIndex = 0;

  _MyHomePageState(this.observer, this.analytics);

  BannerAd _bannerAd;

  void _onItemTapped(int index) {
    this.setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    this._sendAnalyticsEvent();
    _bannerAd = Ads.myTestBanner..load()..show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _selectedIndex == 1
          ? CreateWidget()
          : _selectedIndex == 2 ? HistoryWidget() : BrowseWidget(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library),
            title: Text('Browse'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.create),
            title: Text('Create'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            title: Text('History'),
          ),
        ],
        currentIndex: _selectedIndex,
//        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openImageAsset,
        child: Icon(Icons.photo_library),
      ),
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  _openImageAsset() async {
    File file = await pickImage();
    if (file != null) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        var image = MemeImage();
        image.title = "A modern type of meme";
        image.file = file;
        return CreatePage(
          image: image,
        );
      }));
    }
  }

  Future<void> _sendAnalyticsEvent() async {
    await analytics.logEvent(
      name: 'app_started',
      parameters: <String, dynamic>{
        'Title': 'Hello Human',
        'date': DateTime.now().toIso8601String()
      },
    );
  }
}
