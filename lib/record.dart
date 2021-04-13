import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'FileController.dart';

import 'MoviePlayerWidget.dart';

class Record {
  String _imagePath;
  //ContentType _contentType;

  Record() {
    _imagePath = '';
    //_contentType = ContentType.Picture;
  }

  String getImagePath() {
    return _imagePath;
  }

  void setImagePath(String imagePath) {
    _imagePath = imagePath;
  }

  /*ContentType getContentType() {
    return _contentType;
  }

  void setContentType(ContentType contentType) {
    _contentType = contentType;
  }*/

}

class RecordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ChangeForm());
  }
}

class ChangeForm extends StatefulWidget {
  @override
  _RecordPageDetail createState() {
    return _RecordPageDetail();
  }
}

class _RecordPageDetail extends State<ChangeForm> {
  File _image;
  final picker = ImagePicker();
  List<Record> records = [];
  List<String> recordThumbnailsPath;
  String localPath;
  bool isFirstReload = true;

  @override
  Widget build(BuildContext context) {
    FileController.localPath.then((value) {
      debugPrint('********* Directory *********');
      debugPrint(value);
      debugPrint('*****************************');
      localPath = value;
    });
    if(isFirstReload) {
      records = loadRecords();
      isFirstReload = false;
    }
    print('records Count = ' + records.length.toString());
    return Container(
        padding:
        EdgeInsets.only(left: 20.0, top: 40.0, right: 20.0, bottom: 80.0),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            IconButton(
                icon: ImageIcon(AssetImage('images/icon/icon_camera.png'), size: 35.0),
                onPressed: startingCamera),
            Container(
                width: MediaQuery.of(context).size.width / 2,
                height: 80.0,
                child: SearchBar(onSearch: searchRecord, onItemFound: null)),
            GestureDetector(
                onTap: sortRecord,
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Text('並べ替え', style: TextStyle(fontSize: 18.0)),
                  ImageIcon(AssetImage('images/icon/icon_sort.png'), size: 35.0)
                ]))
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            TextButton(onPressed: showAll, child: Text('すべて')),
            TextButton(onPressed: showVideos, child: Text('ビデオ')),
            TextButton(onPressed: showPictures, child: Text('写真'))
          ]),
          Flexible(
              child: ListView(shrinkWrap: true, children: getRecordLines())
          )
        ])
    );
  }

  void startingCamera() {
    debugPrint('run startingCamera()');
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('データの種類'),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  getImageFromCamera();
                  Navigator.pop(context);
                },
                child: Text('画像'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  getVideoFromCamera();
                  Navigator.pop(context);
                },
                child: Text('動画'),
              )
            ],
          );
        }
    );
  }

  void sortRecord() {
    debugPrint('run sortRecord()');
  }

  void showAll() {
    debugPrint('run showAll()');
  }

  void showVideos() {
    debugPrint('run showVideos()');
  }

  void showPictures() {
    debugPrint('run showPictures()');
  }

  Future<List<Record>> searchRecord(String search) {}

  Future getImageFromCamera() async {
    var imageFile = await picker.getImage(source: ImageSource.camera);
    _image = File(imageFile.path);

    if(imageFile == null) {
      return;
    }

    String fileName = DateTime.now().toString();
    fileName = fileName.replaceAll(' ', '_');
    fileName = fileName.replaceAll(':', '_');
    fileName = fileName.replaceAll('.', '_');
    var savedFile = await FileController.saveLocalImage(_image, fileName + '.png');
    print('saved Picture -> ' + savedFile.toString());
    setState(() {
      _image = savedFile;
      records = loadRecords();
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
      debugPrint(pickedFile.path);
    });
  }

  Future getVideoFromCamera() async {
    PickedFile pickedFile = await picker.getVideo(source: ImageSource.camera);
    var imageFile = File(pickedFile.path);
    var _cameraVideoPlayerController = VideoPlayerController.file(imageFile);

    _image = File(imageFile.path);

    if(imageFile == null) {
      return;
    }

    String fileName = DateTime.now().toString();
    fileName = fileName.replaceAll(' ', '_');
    fileName = fileName.replaceAll(':', '_');
    fileName = fileName.replaceAll('.', '_');
    var savedFile;
    if(Platform.isAndroid) {
      savedFile = await FileController.saveLocalImage(
          _image, fileName + '.mp4');
    } else {
      savedFile = await FileController.saveLocalImage(_image, fileName + '.mov');
    }

    print('saved Picture -> ' + savedFile.toString());
    setState(() {
      _image = savedFile;
      records = loadRecords();
    });
  }

  Future getVideoFromGallery() async {
    final pickedFile = await picker.getVideo(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
      debugPrint(pickedFile.path);
    });
  }

  // すべての記録を表示する
  List<Row> getRecordLines() {
    //１行に4つ記録を表示する
    List<Row> recordLines = [];
    int lineCount = records.length ~/ 4;
    lineCount += records.length % 4 == 0 ? 0 : 1;

    for(int i = 0; i < lineCount; i++) {
      recordLines.add(Row(
          children: getOneLineRecords(i))
      );
    }
    return recordLines;
  }

  /* 1行分の記録を返す */
  List<Expanded> getOneLineRecords(int lineNumber) {
    List<Expanded> oneLineRecords = [];
    int lineCount = records.length ~/ 4;
    lineCount += records.length % 4 == 0 ? 0 : 1;
    int contentCount = lineCount == lineNumber + 1 ? records.length % 4 : 4; // 1行に含まれる記録の数
    int recordNumber;
    for(int i = 0; i < contentCount; i++) {
      recordNumber = lineNumber * 4 + i;
      print('$recordNumber');
      oneLineRecords.add(
          Expanded(
            child: GestureDetector(
              child: Image.file(File(records[recordNumber].getImagePath()), fit: BoxFit.contain),
              onTap: () => onImageTapped(recordNumber),
            )
          )
      );
    }
    if(lineCount == lineNumber + 1) {
      for(int j = 0; j < 4 - records.length % 4; j++) {
        oneLineRecords.add(
            Expanded(child: Image.asset('', fit: BoxFit.contain))
        );
      }
    }

    return oneLineRecords;
  }
  //List<Record> loadRecords()
  List<Record> loadRecords() {
    List<Record> _records = [];

    bool _isRecordLoaded = false;

    FileController.readResourcesPath().then((value) {
      int recordCount = value.length;
      Record _record = new Record();
      for(int i = 0; i < recordCount; i++) {
        print('_record path: ' + value[i].toString());
        _record.setImagePath(value[i]);
        _records.add(_record);
      }
      setState(() {
        print('recordCount: $recordCount');
      });
    });

    return _records;
  }

  void onImageTapped(int recordNumber) {
    print('onImageTapped($recordNumber)');
  }

}