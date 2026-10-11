import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:universal_html/html.dart' as html;

Future<void> downloadCVImpl() async {
  try {
    final ByteData byteData = await rootBundle.load('assets/cv.pdf');
    final Uint8List bytes = byteData.buffer.asUint8List();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'Hammad_Ramzan_CV.pdf')
      ..target = '_blank';
    html.document.body?.append(anchor);
    anchor.click();
    anchor.remove();

    final userAgent = html.window.navigator.userAgent.toLowerCase();
    final isMobileDevice = userAgent.contains('mobile') ||
        userAgent.contains('android') ||
        userAgent.contains('iphone') ||
        userAgent.contains('ipad');
    if (isMobileDevice) {
      html.window.open(url, '_blank');
    }

    Future.delayed(const Duration(seconds: 5), () {
      html.Url.revokeObjectUrl(url);
    });
  } catch (_) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fallbackAnchor = html.AnchorElement(href: 'cv.pdf?v=$timestamp')
      ..setAttribute('download', 'Hammad_Ramzan_CV.pdf')
      ..target = '_blank';
    html.document.body?.append(fallbackAnchor);
    fallbackAnchor.click();
    fallbackAnchor.remove();
  }
}
