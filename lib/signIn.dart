import 'package:flutter/material.dart';
import 'util.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _ChangeForm());
  }
}

class _ChangeForm extends StatefulWidget {
  @override
  _SignInPageDetail createState() {
    return _SignInPageDetail();
  }
}

class _SignInPageDetail extends State<_ChangeForm> {
  String _corpName = "サンプル学校";
  String _appTitle = "学習記録アプリ";
  double _fontSizeBig = 40.0;
  double _fontSizeMiddle = 35.0;
  double _fontSizeSmall = 20.0;
  double _textFieldSize = 300.0;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 30.0, top:40.0, right: 30.0),
        child:
        Column(
            children: <Widget> [
              Text("$_corpName", style: TextStyle(color:Colors.black, fontSize: _fontSizeBig, fontWeight: FontWeight.w500,)),
              Text("$_appTitle", style: TextStyle(color: Colors.black, fontSize: _fontSizeMiddle, fontWeight: FontWeight.w500)),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                    margin: EdgeInsets.only(top: 50.0),
                    child: Text("ログイン", style: TextStyle(fontSize: _fontSizeMiddle))
                )]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                    width: _textFieldSize,
                    color: Colors.white,
                    child: TextField(enabled: true, style: TextStyle(color: Colors.red), decoration: InputDecoration(border: InputBorder.none))
                )]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                    child: Text("会員番号", style: TextStyle(fontSize: _fontSizeMiddle))
                )]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                    width: _textFieldSize,
                    color: Colors.white,
                    margin: EdgeInsets.only(bottom: 50.0),
                    child: TextField(enabled: true, style: TextStyle(color: Colors.red), decoration: InputDecoration(border: InputBorder.none))
                )]
              ),
              FlatButton(onPressed: _signIn, color: Colors.blue, child: Text('ログイン', style: TextStyle(color: Colors.white, fontSize: _fontSizeMiddle))),
              SpaceBox(height: 30.0),
              GestureDetector(onTap: _forgotPassword, child: Text('パスワードを忘れた場合はこちら', style: TextStyle(fontSize: _fontSizeSmall)))
            ])
    );
  }

  void _signIn() {
    // ログイン成功でトップ画面に遷移
    Navigator.pop(context);
    //Navigator.push(context, MaterialPageRoute(builder: (context) => BottomBar()));
  }

  void _forgotPassword() {
    // 「パスワードを忘れた場合はこちら」をタップした時の処理
  }
}