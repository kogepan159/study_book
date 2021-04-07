import 'dart:io';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'record.dart';
import 'report.dart';
import 'package:permission_handler/permission_handler.dart';
import 'util.dart';
import 'config.dart';
import 'text.dart';

enum TabItem {
  home,
  text,
  report,
  record
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      checkPermission();
    }
    return MaterialApp(home: Scaffold(body: Container(child: ChangeForm())));
  }

  Future<Map<Permission, PermissionStatus>> checkPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.photos
    ].request();
    print('storage permission: ' + statuses[Permission.storage].toString());
    print('photos permission: ' + statuses[Permission.photos].toString());
    return statuses;
  }
}

class ChangeForm extends StatefulWidget {
  @override
  _HomePageDetail createState() {
    return _HomePageDetail();
  }
}

class _HomePageDetail extends State<ChangeForm> {
  //TabItem _currentTab = TabItem.home;
  /*Map<TabItem, GlobalKey<NavigatorState>> _navigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.text: GlobalKey<NavigatorState>(),
    TabItem.report: GlobalKey<NavigatorState>(),
    TabItem.record: GlobalKey<NavigatorState>()
  };*/
  double _iconSize = 20.0;
  double _elementSpace = 20.0;
  double _titleSize = 18.0;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 20.0, top: 50.0, right: 20.0),
        child: Column(children: <Widget>[
          /* テキスト */
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ImageIcon(AssetImage('images/icon/icon_text.png'),
                        size: _iconSize),
                    SpaceBox(width: 20.0, height: 0),
                    Text(
                      'テキスト',
                      style: TextStyle(fontSize: _titleSize),
                    )
                  ]),
              IconButton(
                  icon: ImageIcon(AssetImage('images/icon/icon_config.png'), size: _iconSize),
                  onPressed: moveConfig)
            ],
          ),

          /* 教科書サムネイルのスライダー */
          CarouselSlider(
            options: CarouselOptions(
                height: 130.0, viewportFraction: 0.31, initialPage: 0),
            items: [1, 2, 3, 4, 5].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 1.0),
                    child: GestureDetector(
                      onTap: tapText /*(index)*/,
                      child:
                      Image.asset('images/content/text/text_sample$i.png'),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          Row(children: [
            GestureDetector(
              onTap: moveTextList,
              child: Text('すべて表示'),
            )
          ]),
          SpaceBox(height: _elementSpace),

          /* レポート */
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ImageIcon(AssetImage('images/icon/icon_report.png'),
                        size: _iconSize),
                    SpaceBox(width: 20.0, height: 0),
                    Text(
                      'レポート',
                      style: TextStyle(fontSize: _titleSize),
                    )
                  ])
            ],
          ),

          /* レポートのスライダー */
          CarouselSlider(
            options: CarouselOptions(
                height: 100.0, viewportFraction: 0.4, initialPage: 0),
            items: [1, 2, 3, 4, 5].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: GestureDetector(
                      onTap: tapReport,
                      child: Image.asset(
                          'images/content/report/report.png'),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          Row(children: [
            GestureDetector(
              onTap: moveReportList,
              child: Text('すべて表示'),
            )
          ]),
          SpaceBox(height: _elementSpace),

          /* 記録 */
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ImageIcon(AssetImage('images/icon/icon_record.png'),
                        size: _iconSize),
                    SpaceBox(width: 20.0, height: 0),
                    Text(
                      '記録',
                      style: TextStyle(fontSize: _titleSize),
                    )
                  ])
            ],
          ),

          /* 記録のスライダー */
          CarouselSlider(
            options: CarouselOptions(
                height: 100.0, viewportFraction: 0.4, initialPage: 0),
            items: [1, 2, 3, 4, 5].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: GestureDetector(
                        onTap: tapRecord,
                        child: Column(
                          children: [
                            Image.asset(
                                'images/content/record/record.png'),
                            Text('タイトルA', style: TextStyle(fontSize: 8.3))
                          ],
                        )),
                  );
                },
              );
            }).toList(),
          ),
          Row(children: [
            GestureDetector(
              onTap: moveRecordList,
              child: Text('すべて表示'),
            )
          ]),
        ]));
  }

  void moveConfig() {
    // 設定画面に遷移する
    Navigator.push(context, MaterialPageRoute(builder: (context) => ConfigPage()));
  }

  void tapText(/*index*/) {
    //テキストのサムネイルがタップされたら該当のテキストの詳細を開く
    debugPrint('run tapText()');
  }

  void tapReport() {
    debugPrint('run tapReport()');
  }

  void tapRecord() {
    debugPrint('run tapRecord()');
  }

  void moveTextList() {
    //テキストのサムネイル画像下の「すべて表示」をタップした時にテキストの一覧を表示する
    debugPrint('run moveTextList()');
    Navigator.push(context, MaterialPageRoute(builder: (context) => TextPage()));
  }

  void moveReportList() {
    debugPrint('run moveReportList()');
    Navigator.push(context, MaterialPageRoute(builder: (context) => ReportPage()));
  }

  void moveRecordList() {
    debugPrint('run moveRecordList()');
    Navigator.push(context, MaterialPageRoute(builder: (context) => RecordPage()));
  }
}
