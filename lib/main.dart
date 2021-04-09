import 'package:flutter/material.dart';
import 'record.dart';
import 'text.dart';
import 'report.dart';
import 'home.dart';

int selectedIndex = 0;
bool isUpdateState = false;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: _ChangeForm()));
  }
}

class _ChangeForm extends StatefulWidget {
  @override
  MainPageState createState() {
    return MainPageState();
  }
}

class MainPageState extends State<_ChangeForm> {
  static List<Widget> _pageList = [
    HomePage(),
    TextPage(),
    ReportPage(),
    RecordPage()
  ];

  /* home.dartの特定のフラグを監視してフラグが立ったらsetStateをはしらせる */
  void updateState() {
    /*if(isUpdateState) {
      setState(() {});
      isUpdateState = false;
    }*/
    setState(() {});
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    print('selectedIndex = $selectedIndex');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageList[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('images/icon/icon_home.png')),
              label: 'ホーム'),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('images/icon/icon_text.png')),
              label: 'テキスト'),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('images/icon/icon_report.png')),
              label: 'レポート'),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('images/icon/icon_record.png')),
              label: '記録')
        ],
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

}