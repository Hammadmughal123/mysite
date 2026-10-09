part of '../services.dart';

class _ServiceCard extends StatefulWidget {
  final ServicesUtils service;
  final double cardWidth;
  final double cardHeight;

  const _ServiceCard({
    Key? key,
    required this.service,
    this.cardWidth = 300,
    this.cardHeight = 380,
  }) : super(key: key);

  @override
  _ServiceCardState createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => isHover = true),
      onExit: (_) => setState(() => isHover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        width: widget.cardWidth,
        height: widget.cardHeight,
        transform: Matrix4.identity()
          ..translate(0.0, isHover ? -8.0 : 0.0),
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
        decoration: BoxDecoration(
          gradient: isHover ? pinkpurple : theme.serviceCard,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isHover ? [primaryColorShadow] : [blackColorShadow],
          border: Border.all(
            color: isHover
                ? Colors.purple.withOpacity(0.5)
                : Colors.white.withOpacity(0.06),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top: Icon
            Container(
              width: 68,
              height: 68,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    primaryColor.withOpacity(0.2),
                    secondaryColor.withOpacity(0.15),
                  ],
                ),
                border: Border.all(
                  color: isHover
                      ? Colors.white70
                      : primaryColor.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: widget.service.icon.endsWith('.png')
                  ? Image.asset(widget.service.icon, fit: BoxFit.contain)
                  : SvgPicture.asset(widget.service.icon, fit: BoxFit.contain),
            ),
            // Title
            SizedBox(
              height: 48,
              child: Center(
                child: Text(
                  widget.service.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isHover ? Colors.white : theme.textColor,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ),
            // Description
            SizedBox(
              height: 72,
              child: Center(
                child: Text(
                  widget.service.description,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isHover
                        ? Colors.white.withOpacity(0.9)
                        : theme.textColor.withOpacity(0.7),
                    fontWeight: FontWeight.w300,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ),
            ),
            // Divider
            Container(
              height: 1,
              width: 50,
              color: isHover
                  ? Colors.white.withOpacity(0.4)
                  : Colors.white.withOpacity(0.12),
            ),
            // Tools pills
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 6,
              children: widget.service.tool.map((tool) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isHover
                        ? Colors.white.withOpacity(0.2)
                        : primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isHover
                          ? Colors.white.withOpacity(0.4)
                          : primaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    tool,
                    style: TextStyle(
                      color: isHover ? Colors.white : theme.textColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> downloadCV() async {
  if (kIsWeb) {
    // Web download
    try {
      final response =
          await html.HttpRequest.request('assets/cv.pdf', responseType: 'blob');
      final blob = html.Blob([response.response]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "resume.pdf")
        ..click();
      html.Url.revokeObjectUrl(url);
      print('CV downloaded successfully on web');
    } catch (e) {
      print('Web download error: $e');
    }
  } else {
    // Mobile download
    try {
      // Request storage permissions
      bool permissionGranted = await _requestStoragePermission();
      if (!permissionGranted) {
        print('Storage permission denied');
        return;
      }

      // Load PDF from assets
      final ByteData byteData = await rootBundle.load('assets/cv.pdf');
      final Uint8List pdfBytes = byteData.buffer.asUint8List();

      // Get the appropriate directory
      Directory? directory = await _getDownloadDirectory();
      if (directory == null) {
        print('Could not access download directory');
        return;
      }

      // Create file path
      final String fileName =
          'resume_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final File file = File('${directory.path}/$fileName');

      // Write file
      await file.writeAsBytes(pdfBytes);

      print('PDF saved to: ${file.path}');

      // Verify file was created
      if (await file.exists()) {
        print('File exists, size: ${await file.length()} bytes');

        // Try to open or share the file
        //    await _handleFileAfterDownload(file);
      } else {
        print('File was not created successfully');
      }
    } catch (e) {
      print('Mobile download error: $e');
    }
  }
}

Future<bool> _requestStoragePermission() async {
  if (Platform.isAndroid) {
    // For Android 13+ (API 33+), we need different permissions
    if (await _isAndroid13OrHigher()) {
      // Android 13+ doesn't need WRITE_EXTERNAL_STORAGE for app-specific directories
      return true;
    } else {
      // For older Android versions
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        // Try requesting manage external storage for Android 11+
        final manageStatus = await Permission.manageExternalStorage.request();
        return manageStatus.isGranted;
      }
      return status.isGranted;
    }
  } else if (Platform.isIOS) {
    // iOS doesn't need explicit storage permission for app documents
    return true;
  }
  return true;
}

Future<bool> _isAndroid13OrHigher() async {
  if (Platform.isAndroid) {
    try {
      // You can check Android version here if needed
      return false; // For now, assume older version
    } catch (e) {
      return false;
    }
  }
  return false;
}

Future<Directory?> _getDownloadDirectory() async {
  try {
    if (Platform.isAndroid) {
      // Try multiple directory options for Android

      // Option 1: External storage directory (if available)
      Directory? externalDir = await getExternalStorageDirectory();
      if (externalDir != null) {
        // Create Downloads subfolder
        Directory downloadDir = Directory('${externalDir.path}/Downloads');
        if (!await downloadDir.exists()) {
          await downloadDir.create(recursive: true);
        }
        return downloadDir;
      }

      // Option 2: Application documents directory
      return await getApplicationDocumentsDirectory();
    } else if (Platform.isIOS) {
      // For iOS, use application documents directory
      return await getApplicationDocumentsDirectory();
    }
  } catch (e) {
    print('Error getting download directory: $e');
  }

  // Fallback to application documents directory
  try {
    return await getApplicationDocumentsDirectory();
  } catch (e) {
    print('Error getting fallback directory: $e');
    return null;
  }
}

// Future<void> _handleFileAfterDownload(File file) async {
//   try {
//     if (Platform.isAndroid) {
//       // Try to open the file first
//       final result = await OpenFile.open(file.path);
//       print('Open file result: ${result.message}');
      
//       if (result.type != ResultType.done) {
//         // If opening failed, try sharing
//         await _shareFile(file);
//       }
//     } else if (Platform.isIOS) {
//       // For iOS, sharing is usually the better option
//       await _shareFile(file);
//     }
//   } catch (e) {
//     print('Error handling file after download: $e');
//     // Fallback to sharing
//     await _shareFile(file);
//   }
// }

// Future<void> _shareFile(File file) async {
//   try {
//     final XFile xFile = XFile(file.path);
//     await Share.shareXFiles(
//       [xFile], 
//       text: 'Download my resume',
//       subject: 'Resume PDF'
//     );
//     print('File shared successfully');
//   } catch (e) {
//     print('Error sharing file: $e');
//   }
// }


// void downloadCV() async {
//   if (kIsWeb) {
//     // Web download
//     final blob = html.Blob([
//       await html.HttpRequest.request('assets/cv.pdf', responseType: 'blob')
//     ]);
//     final url = html.Url.createObjectUrlFromBlob(blob);
//     final anchor = html.AnchorElement(href: url)
//       ..setAttribute("download", "resume.pdf")
//       ..click();
//     html.Url.revokeObjectUrl(url);
//   } else {
//     // Mobile
//     final status = await Permission.storage.request();
//     if (!status.isGranted) {
//       print('Permission denied');
//       return;
//     }

//     // Load from assets
//     final byteData = await rootBundle.load('assets/cv.pdf');

//     // Get path to save
//     final dir = await getExternalStorageDirectory();
//     final file = File('${dir!.path}/resume.pdf');

//     // Write to file
//     await file.writeAsBytes(byteData.buffer.asUint8List());

//     // Optional: Share or open
//     await Share.shareXFiles([XFile(file.path)], text: 'Download my resume');
//     print('PDF saved to ${file.path}');
//   }

