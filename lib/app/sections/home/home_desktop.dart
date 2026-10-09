// import 'package:flutter/foundation.dart';
// import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:mysite/app/sections/home/widgets/animation_text.dart';
import 'package:mysite/core/animations/zoom_animation.dart';
import 'package:mysite/core/res/responsive_size.dart';
import 'package:sizer/sizer.dart';
import 'package:universal_html/html.dart' as html;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:mysite/app/widgets/color_chage_btn.dart';
import 'package:mysite/changes/img.dart';
import 'package:mysite/changes/links.dart';
import 'package:mysite/changes/strings.dart';
import 'package:mysite/core/animations/entrance_fader.dart';
import 'package:mysite/core/configs/configs.dart';

import '../services/services.dart';

class HomeDesktop extends StatelessWidget {
  const HomeDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;

    return Container(
      constraints: const BoxConstraints(minHeight: 640),
      padding: EdgeInsets.symmetric(
        horizontal: (width * 0.06).clamp(32.0, 120.0),
        vertical: 60,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1300),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 40.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            hellotag,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(width: 8),
                          EntranceFader(
                            offset: const Offset(0, 0),
                            delay: const Duration(seconds: 1),
                            duration: const Duration(milliseconds: 800),
                            child: Image.asset(StaticImage.hi, height: 36),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        yourname,
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "A ",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Flexible(
                            child: AnimatedTextKit(
                              isRepeatingAnimation: true,
                              repeatForever: true,
                              animatedTexts: desktopList,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        miniDescription,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: theme.textColor.withOpacity(0.7),
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 32),
                      ColorChageButton(
                        text: 'Download CV',
                        onTap: () {
                          downloadCV();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const ZoomAnimations(),
            ],
          ),
        ),
      ),
    );
  }
}
