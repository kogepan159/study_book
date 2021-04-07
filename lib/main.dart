import 'package:flutter/material.dart';
import 'record.dart';
import 'text.dart';
import 'report.dart';
import 'home.dart';

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
  _MainPageState createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<_ChangeForm> {
  static List<Widget> _pageList = [
    HomePage(),
    TextPage(),
    ReportPage(),
    RecordPage()
  ];
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageList[_selectedIndex],
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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  void setSelectedPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}