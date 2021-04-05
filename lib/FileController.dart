import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FileController {
  static Future get localPath async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

  static Future saveLocalImage(File image, String fileName) async {
    final path = await localPath;
    await Directory('$path/StudyBook').create(recursive: true);
    final imagePath = '$path/StudyBook/$fileName';
    File imageFile = File(imagePath);

    var savedFile = await image.copy(imagePath);
    print('save directory -> $imagePath');
    return savedFile;
  }

  static Future loadLocalImage(String fileName) async {
    final path = await localPath;
    final imagePath = '$path/StudyBook/$fileName';

    return File(imagePath);
  }

  static Future printResourcesPath() async {
    final path = await localPath;
    List<String> imagesPath = new List<String>();
    final directory = await Directory('$path/StudyBook/');
    print(directory.path.toString());

    await for (var entity in
    directory.list(recursive: true, followLinks: false)) {
      imagesPath.add(entity.path);
    }

    return imagesPath;
  }


}