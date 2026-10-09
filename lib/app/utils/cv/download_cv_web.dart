import 'package:universal_html/html.dart' as html;

Future<void> downloadCVImpl() async {
  try {
    final anchor = html.AnchorElement(href: 'cv.pdf')
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
      html.window.open('cv.pdf', '_blank');
    }
  } catch (_) {
    html.window.open('cv.pdf', '_blank');
  }
}
