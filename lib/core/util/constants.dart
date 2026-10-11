import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';

// URL Launcher
void openURL(String url) async {
  if (kIsWeb && (url.startsWith('mailto:') || url.startsWith('tel:'))) {
    final anchor = html.AnchorElement(href: url);
    anchor.click();
    return;
  }
  final uri = Uri.parse(url);
  try {
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      await launchUrl(uri);
    }
  } catch (_) {
    try {
      await launchUrl(uri);
    } catch (_) {}
  }
}
