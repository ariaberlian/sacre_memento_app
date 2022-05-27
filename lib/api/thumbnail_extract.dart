import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:image/image.dart';

class ThumbnailExtractor {
  static Future<String> extract(File file, String type, String name) async {
    final List<int>? thumb;
    if (type == 'video') {
      thumb = await VideoThumbnail.thumbnailData(
        video: file.path,
        imageFormat: ImageFormat.PNG,
        maxWidth:
            128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        quality: 25,
      );
    } else {
      // type = photo
      Image? image = decodeImage(file.readAsBytesSync());
      thumb = encodePng(copyResize(image!, width: 120));
    }

    Directory? dir = await getApplicationDocumentsDirectory();
    File thumbnail = await File('${dir.path}/thumb$name.png').create();
    thumbnail.writeAsBytes(thumb!);
    return '${dir.path}/thumb$name.png';
  }

}
