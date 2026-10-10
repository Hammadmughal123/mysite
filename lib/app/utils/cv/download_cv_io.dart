import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> downloadCVImpl() async {
  try {
    final ByteData byteData = await rootBundle.load('assets/cv.pdf');
    final Uint8List pdfBytes = byteData.buffer.asUint8List();
    final Directory tempDir = await getTemporaryDirectory();
    final File file = File('${tempDir.path}/Hammad_Ramzan_CV.pdf');
    await file.writeAsBytes(pdfBytes);
    // ignore: deprecated_member_use
    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Hammad Ramzan Resume',
      subject: 'Hammad Ramzan CV',
    );
  } catch (e) {
    // ignore: avoid_print
    print('Mobile download error: $e');
  }
}
