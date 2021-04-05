import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'FileController.dart';

import 'MoviePlayerWidget.dart';

enum ContentType {
  Picture,
  Video
}

class Record {
  String _imagePath;
  ContentType _contentType;

  Record() {
    _imagePath = '';
    _contentType = ContentType.Picture;
  }

  String getImagePath() {
    return _imagePath;
  }

  void setImagePath(String imagePath) {
    _imagePath = imagePath;
  }

  ContentType getContentType() {
    return _contentType;
  }

  void setContentType(ContentType contentType) {
    _contentType = contentType;
  }

}

class RecordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: ChangeForm()));
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
  List<Record> records = new List();
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
    printFilePaths();
    return Container(
        padding:
        EdgeInsets.only(left: 20.0, top: 40.0, right: 20.0, bottom: 80.0),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            IconButton(
                icon: ImageIcon(AssetImage('images/icon/icon_camera.png'), size: 35.0),
                onPressed: startingCamera),
            //Text('検索バー'),
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
    //selectCaptureMode();
    //getVideoFromCamera();
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

    var savedFile = await FileController.saveLocalImage(_image, DateTime.now().toString() + '.png');

    setState(() {
      _image = savedFile;
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
    var _cameraVideo = File(pickedFile.path);
    var _cameraVideoPlayerController = VideoPlayerController.file(_cameraVideo);

    setState(() {
      debugPrint(pickedFile.path);
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
    List<Row> recordLines = new List();
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
    List<Expanded> oneLineRecords = new List();
    int lineCount = records.length ~/ 4;
    lineCount += records.length % 4 == 0 ? 0 : 1;
    int contentCount = lineCount == lineNumber + 1 ? records.length % 4 : 4; // 1行に含まれる記録の数
    int recordNumber;
    for(int i = 0; i < contentCount; i++) {
      recordNumber = lineNumber * 4 + i;
      oneLineRecords.add(
          Expanded(child: Image.file(File(records[recordNumber].getImagePath()), fit: BoxFit.contain))
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

  List<Record> loadRecords() {
    List<Record> _records = new List();
    Record _record;

    for(int i = 0; i < 83; i++) {
      _record = new Record();
      _record.setImagePath('images/content/record/record.png');
      _record.setContentType(ContentType.Picture);
      if(i == 2) {
        _record.setImagePath('images/content/record/record.mp4');
        _record.setContentType(ContentType.Video);
      }
      _records.add(_record);
    }

    return _records;
  }

  Future printFilePaths() async {
    FileController.printResourcesPath().then((value) {
      recordThumbnailsPath = new List();
      print('length = ' + value.length.toString());
      for(int a = 0; a < value.length; a++) {
        print('*** ' + value[a]);
        recordThumbnailsPath.add(value[a]);
      }
      updateRecordImages();
    });
  }

  Future updateRecordImages() async {
    bool isUpdated = false;
    for(int i = 0; i < recordThumbnailsPath.length; i++) {
      if(records[i].getImagePath() != recordThumbnailsPath[i]) {
        print('不一致！ ' + records[i].getImagePath());
        print(recordThumbnailsPath[i]);
        records[i].setImagePath(recordThumbnailsPath[i]);
        isUpdated = true;
        print(records[i].getImagePath());
      }
    }
    if(isUpdated) {
      setState(() {});
    }
  }

}