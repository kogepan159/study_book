import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:study_book/util.dart';
import 'package:video_player/video_player.dart';
import 'FileController.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'MoviePlayerWidget.dart';

Future<Uint8List> getThumbnail(String videoPath) async {
  Uint8List bytes;
  //final Completer<ThumbnailResult> completer = Completer();
  bytes = await VideoThumbnail.thumbnailData(video: videoPath);
  print('Bytes = ' + bytes.toString());

  return bytes;
  /*final _image = Image.memory(bytes);
  print(_image);
  completer.complete(ThumbnailResult(image: _image));

  return completer.future;*/
}

class Record {
  String _imagePath;

  Record() {
    _imagePath = '';
  }

  String getImagePath() {
    return _imagePath;
  }

  void setImagePath(String imagePath) {
    _imagePath = imagePath;
  }

}

class ThumbnailResult {
  final Image image;
  const ThumbnailResult({this.image});
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
  FileUtility fileUtility = new FileUtility();

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
    //var _cameraVideoPlayerController = VideoPlayerController.file(imageFile);

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
    for(int i = 0; i < contentCount; i++) {
      // TODO: 画像ならImage.fileで参照、動画ならサムネイルを生成してImage.memoryで参照
      FileType fileType = fileUtility.getFileType(records[lineNumber * 4 + i].getImagePath());
      String imagePath = records[lineNumber * 4 + i].getImagePath();
      if(fileType == FileType.Image) {
        oneLineRecords.add(
          Expanded(
            child: GestureDetector(
              child: Image.file(File(imagePath),
              fit: BoxFit.contain),
              onTap: () => onImageTapped(lineNumber * 4 + i),
            )
          )
        );
      } else if(fileType == FileType.Movie) {
        print('FileType Movie Record Running...');
        print('imagePath(getThumbnail) = ' + imagePath);
        // Image.memoryに格納するImageのバイト列を取得する
        oneLineRecords.add(
            Expanded(
              child: FutureBuilder(
                  future: getThumbnail(imagePath),
                  // ignore: missing_return
                  builder: (BuildContext context, AsyncSnapshot<Uint8List> bytes) {
                  if (bytes.hasData) {
                    return Image.memory(bytes.data);
                    return Text("読み込み中");
                  }
                  // 非同期処理で取得したデータを使用して、　Widgetを生成する
                  return Text("読み込み中");
               }
              )
            )
        );
      }
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
    List<Record> _records = [];

    FileController.readResourcesPath().then((value) {
      int recordCount = value.length;

      for(int i = 0; i < recordCount; i++) {
        Record _record = new Record();
        //print('value[$i] path: ' + value[i].toString());
        print('*** Image Property ***');
        print('No.$i Record');
        FileType fileType = fileUtility.getFileType(value[i].toString());
        print('ImagePath: ' + value[i].toString());
        print('FileType: ' + fileType.toString());
        print('**********************');
        if(fileType == FileType.Image || fileType == FileType.Movie) {
          _record.setImagePath(value[i].toString());
        } else { // ファイルが画像でも動画でもない
          // 例外
          _record.setImagePath(''); // 画像は配置されず空白になる
        }
        //print('_record path: ' + _record.getImagePath());
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
    print('records[$recordNumber] path: ${records[recordNumber].getImagePath()}');



    //TODO: 写真/動画サムネイルをクリックした時の詳細ページを生成して遷移する
    Navigator.push(context, MaterialPageRoute(builder: (context) => RecordDetail(imagePath: records[recordNumber].getImagePath()))).then((value) => {
      print('received Message => $value')
    });
  }

}

class RecordDetail extends StatelessWidget {
  final String imagePath;

  RecordDetail({Key key, @required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 50.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton( //戻るボタン
                  icon: ImageIcon(AssetImage('images/icon/icon_arrow.png'), size: 40.0),
                  onPressed: () => Navigator.pop(context))
            ]),
            Image.file(File(imagePath)), //Record詳細（動画の場合は動画）,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton( //Record削除ボタン
                  icon: ImageIcon(AssetImage('images/icon/icon_remove.png'), size: 40.0),
                  onPressed: () => Navigator.pop(context, "remove Message")
                )
              ]
            )
          ]
        )
      )
    );
  }


}
/*
class GenThumbnailImage extends StatefulWidget {
  final videoPath;
  const GenThumbnailImage({Key key, this.videoPath});

  @override
  _GenThumbnailImageState createState() => _GenThumbnailImageState();
}

class _GenThumbnailImageState extends State<GenThumbnailImage> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ThumbnailResult> (
      future: getThumbnail(widget.videoPath),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData) {
          final _image = snapshot.data.image;
          return Image(image: _image);
        } else {
          return Image.file(File(''));
        }
      }
    );
  }
}*/