import 'package:flutter/material.dart';

class SpaceBox extends SizedBox {
  SpaceBox({double width = 8, double height = 8})
      : super(width: width, height: height);

  SpaceBox.width([double value = 8]) : super(width: value);
  SpaceBox.height([double value = 8]) : super(height: value);
}

/* ファイルの種類 */
enum FileType {
  Image,  // 画像
  Movie,  // 動画
  Other   // その他のファイル
}

class FileUtility {

  /* 指定したパスのファイルの種類(FileType(Image,Movie,Other))を返す */
  FileType getFileType(String filePath) {
    filePath = 'testDir/test.png';
    int textLength = filePath.length;
    int extPoint = 0;

    for(int i = textLength - 1; i >= 0; i--) {
      if(filePath[i] != '.') {
        continue;
      } else {
        extPoint = i;
        break;
      }
    }
    if(extPoint == 0) { //拡張子が存在しないファイル名
      //例外
    }
    String extension = filePath.substring(extPoint + 1, textLength); //ファイル拡張子
    switch(extension) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      return FileType.Image;
      case 'mp4':
      case 'mov':
        return FileType.Movie;
      default:
        return FileType.Other;
    }
  }

}