import 'package:flutter/material.dart';
import 'package:study_book/main.dart';
import 'home.dart';
import 'util.dart';

class ConfigPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(
        body: Container(
            child: ChangeForm()),
        backgroundColor: Colors.black54));
  }
}

class ChangeForm extends StatefulWidget {
  @override
  _ConfigPageDetail createState() {
    return _ConfigPageDetail();
  }
}

class _ConfigPageDetail extends State<ChangeForm> {
  String userName = '田中太郎';
  double _fontSize = 15.0;
  double _textFieldWidth = 250.0;
  double _textFieldHeight = 40.0;
  bool _canChangePassword = false;
  Color _disabledColor = Colors.white24;
  Color _enabledColor = Colors.white;
  Color _passwordAreaColor = Colors.white24;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20.0, top: 40.0, right: 20.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(icon: ImageIcon(AssetImage('images/icon/icon_cancel.png'), color: Colors.white70), onPressed: cancel)
            ],
          ),

          /* アカウント */
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('アカウント', style: TextStyle(color: Colors.white, fontSize: _fontSize)),
              SpaceBox(width: 40.0),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(userName, style: TextStyle(color: Colors.white, fontSize: _fontSize)),
                    FlatButton(color: Colors.grey, onPressed: signOut, child: Text('ログアウト', style: TextStyle(color: Colors.black)))
                  ]
              )
            ],
          ),

          SpaceBox(height:20.0),

          /* 登録情報 */
          Row(
            children: [
              Text('登録情報', style: TextStyle(color: Colors.white, fontSize: _fontSize)),
              SpaceBox(width: 50.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('学年：3年生　クラス：2組', style: TextStyle(color: Colors.white, fontSize: _fontSize)),
                  Text('所属教室：横浜教室', style: TextStyle(color: Colors.white, fontSize: _fontSize)),
                  Text('コース：基礎研究、Sテック', style: TextStyle(color: Colors.white, fontSize: _fontSize)),
                  Text('メールアドレス：aaaaaa@aaa', style: TextStyle(color: Colors.white, fontSize: _fontSize))
                ],
              )
            ],
          ),

          /* パスワード */
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('パスワード', style: TextStyle(color: Colors.white, fontSize: _fontSize)),
              SpaceBox(width: 25.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Checkbox(activeColor: Colors.blueAccent, value: _canChangePassword, onChanged: toggleChangePassword),
                      Text('パスワードを変更する', style: TextStyle(color: _passwordAreaColor, fontSize: _fontSize))
                    ],
                  ),
                  Text('現在のパスワード', style: TextStyle(color: Colors.white, fontSize: _fontSize)),
                  Container(
                      width: _textFieldWidth,
                      height: _textFieldHeight,
                      color: _passwordAreaColor,
                      child: TextField(obscureText: true, enabled: _canChangePassword, decoration: InputDecoration(border: InputBorder.none))
                  ),
                  Text('新しいパスワード', style: TextStyle(color: Colors.white, fontSize: _fontSize)),
                  Container(
                      width: _textFieldWidth,
                      height: _textFieldHeight,
                      color: _passwordAreaColor,
                      child: TextField(obscureText: true, enabled: _canChangePassword, decoration: InputDecoration(border: InputBorder.none))
                  ),
                  SpaceBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SpaceBox(width: 160.0),
                      FlatButton(color: Colors.grey, onPressed: changePassword, child: Text('変更する'))
                    ],
                  ),
                ],
              )
            ],
          ),

          SpaceBox(height: 30.0),

          /* デザイン */
          Row(
            children: [
              Text('デザイン', style: TextStyle(color: Colors.white, fontSize: _fontSize)),
              SpaceBox(width: 30.0),
              Row(
                children: [
                  TextButton(onPressed: selectDesignAnimal, child: Text('どうぶつ', style: TextStyle(color: Colors.white, fontSize: _fontSize))),
                  SpaceBox(width: 30.0),
                  TextButton(onPressed: selectDesignCosmos, child: Text('宇宙', style: TextStyle(color: Colors.white, fontSize: _fontSize))),
                ],
              )
            ],
          ),

          SpaceBox(height: 20.0),

          /*表示設定*/
          Row(
            children: [
              Text('表示設定', style: TextStyle(color: Colors.white, fontSize: _fontSize)),
              SpaceBox(width: 30.0),
              Row(
                children: [
                  TextButton(onPressed: selectDesignAnimal, child: Text('漢字', style: TextStyle(color: Colors.white, fontSize: _fontSize))),
                  SpaceBox(width: 30.0),
                  TextButton(onPressed: selectDesignAnimal, child: Text('ひらがな', style: TextStyle(color: Colors.white, fontSize: _fontSize))),
                ],
              )
            ],
          )

        ],
      ),
    );
  }

  void cancel() {
    //キャンセルボタンを押した時の遷移処理
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
    //Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  void signOut() {
    //ログアウトボタンを押した時の処理
    debugPrint('run signOut()');
  }

  void toggleChangePassword(bool checkBoxState) {
    //パスワードのチェックボックスをタップした時の処理
    setState(() {
      _canChangePassword = checkBoxState;
      _passwordAreaColor = _canChangePassword ? _enabledColor : _disabledColor;
    });
  }

  void selectDesignAnimal() {
    debugPrint('run selectDesignAnimal()');
  }

  void selectDesignCosmos() {
    debugPrint('run selectDesignCosmos()');
  }

  void setDisplayKanji() {
    debugPrint('run setDisplayKanji()');
  }

  void setDisplayHiragana() {
    debugPrint('run setDisplayHiragana()');
  }

  void changePassword() {
    //パスワード欄の「変更する」ボタンを押した時の処理
    debugPrint('run changePassword()');

    if(!_canChangePassword) {
      return;
    }

    debugPrint('changed Password');
  }
}