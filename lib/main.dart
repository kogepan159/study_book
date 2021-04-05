import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'record.dart';
import 'text.dart';
import 'report.dart';
import 'home.dart';

enum TabItem {
  home,
  text,
  report,
  record
}

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
  //TabItem _currentTab = TabItem.home;
  /*Map<TabItem, GlobalKey<NavigatorState>> _navigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.text: GlobalKey<NavigatorState>(),
    TabItem.report: GlobalKey<NavigatorState>(),
    TabItem.record: GlobalKey<NavigatorState>()
  };*/

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('images/icon/icon_home.png')),
                label: 'ホーム'
            ),
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('images/icon/icon_text.png')),
                label: 'テキスト'
            ),
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('images/icon/icon_report.png')),
                label: 'レポート'
            ),
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('images/icon/icon_record.png')),
                label: '記録'
            )
          ],
        ),
        tabBuilder: (context, index) {
          switch (index) {
            case 0:
              return CupertinoTabView(builder: (context) {
                return CupertinoPageScaffold(
                    child: HomePage()
                );
              });
            case 1:
              return CupertinoTabView(builder: (context) {
                return CupertinoPageScaffold(
                    child: TextPage()
                );
              });
            case 2:
              return CupertinoTabView(builder: (context) {
                return CupertinoPageScaffold(
                    child: ReportPage()
                );
              });
            case 3:
              return CupertinoTabView(builder: (context) {
                return CupertinoPageScaffold(
                    child: RecordPage()
                );
              });
          }
        });
  }
/*
    return Scaffold(
        body: Stack(
          children: <Widget>[
            _buildTabItem(
                TabItem.home,
                '/home'
            ),
            _buildTabItem(
                TabItem.text,
                '/text'
            ),
            _buildTabItem(
                TabItem.report,
                '/report'
            ),
            _buildTabItem(
                TabItem.record,
                '/record'
            )
          ],
        ),
        bottomNavigationBar: BottomNavigation(
            currentTab: _currentTab,
            onSelect: onSelect
        )
    );
    if(authed) {
      return HomePage();
    } else {
      return SignInPage();
    }
  }

  Widget _buildOffstageNavigator(TabItem tabItem) {
    return Offstage(
        offstage: _currentTab != tabItem,
        child: TabNavigator(
          navigationKey: _navigatorKeys[tabItem],
          tabItem: _currentTab
        )
    );
  }

  void onSelect(TabItem tabItem) {
    if(_currentTab == tabItem) {
      _navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentTab = tabItem;
      });
    }
  }

  Future<bool> onWillPop() async {
    final isFirstRouteInCurrentTab = !await _navigatorKeys[_currentTab].currentState.maybePop();
    if(isFirstRouteInCurrentTab) {
      if(_currentTab != TabItem.home) {
        onSelect(TabItem.home);
        return false;
      }
    }
    return isFirstRouteInCurrentTab;
  }

  void _selectTab(TabItem tabItem) {
    if(tabItem == _currentTab) {
      _navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }*/

}

/*
class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                items: const [
                  BottomNavigationBarItem(icon: ImageIcon(AssetImage('images/icon/icon_home.png')), label: 'ホーム'),
                  BottomNavigationBarItem(icon: ImageIcon(AssetImage('images/icon/icon_text.png')), label: 'テキスト'),
                  BottomNavigationBarItem(icon: ImageIcon(AssetImage('images/icon/icon_report.png')), label: 'レポート'),
                  BottomNavigationBarItem(icon: ImageIcon(AssetImage('images/icon/icon_record.png')), label: '記録')
                ]
            )
        )
    );
  }
}*/