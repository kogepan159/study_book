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
  MainPageState createState() {
    return MainPageState();
  }
}

class MainPageState extends State<_ChangeForm> {
  int selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    print('selectedIndex = $selectedIndex');
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> _pageList = [
      HomePage(this),
      TextPage(),
      ReportPage(),
      RecordPage()
    ];
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
        onTap: onItemTapped,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

}