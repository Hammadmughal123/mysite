part of '../services.dart';

class _ServiceCard extends StatefulWidget {
  final ServicesUtils service;

  const _ServiceCard({Key? key, required this.service}) : super(key: key);

  @override
  _ServiceCardState createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {},
      onHover: (isHovering) {
        if (isHovering) {
          setState(() => isHover = true);
        } else {
          setState(() => isHover = false);
        }
      },
      child: Container(
        width: Responsive.isTablet(context) ? 400 : 300,
        // height: AppDimensions.normalize(100),
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        decoration: BoxDecoration(
          // gradient: isHover ? pinkpurple : grayBack,
          gradient: isHover ? pinkpurple : theme.serviceCard,
          borderRadius: BorderRadius.circular(15),
          boxShadow: isHover ? [primaryColorShadow] : [blackColorShadow],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SvgPicture.asset(
            //   widget.service.icon,
            //   height: 60,
            // ),

            widget.service.icon.endsWith('.png')
                ? Image.asset(
                    widget.service.icon,
                    height: 60,
                  )
                : SvgPicture.asset(
                    widget.service.icon,
                    height: 60,
                  ),
            Space.y(3.w)!,
            Text(widget.service.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isHover ? whiteColor : theme.textColor,
                )),
            Space.y(1.w)!,
            Text(
              widget.service.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isHover ? whiteColor.withOpacity(0.8) : theme.textColor,
                fontWeight: FontWeight.w200,
                fontSize: 13,
              ),
            ),
            Space.y(2.w)!,
            if (Responsive.isDesktop(context))
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.service.tool
                      .map((e) => Row(
                            children: [
                              const Text('🛠   '),
                              Text(e,
                                  style: TextStyle(
                                    color:
                                        isHover ? whiteColor : theme.textColor,
                                  )),
                            ],
                          ))
                      .toList()),
            if (Responsive.isMobile(context) || Responsive.isTablet(context))
              Expanded(
                child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: widget.service.tool
                        .map((e) => Row(
                              children: [
                                const Text('🛠   '),
                                Text(e,
                                    style: TextStyle(
                                      color: isHover
                                          ? whiteColor
                                          : theme.textColor,
                                    )),
                              ],
                            ))
                        .toList()),
              )
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

