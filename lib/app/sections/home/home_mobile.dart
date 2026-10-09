import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:mysite/app/utils/cv/download_cv.dart';
import 'package:mysite/app/widgets/color_chage_btn.dart';
import 'package:mysite/changes/img.dart';
import 'package:mysite/changes/links.dart';
import 'package:mysite/changes/strings.dart';
import 'package:mysite/core/animations/entrance_fader.dart';
import 'package:mysite/core/animations/zoom_animation.dart';
import 'package:mysite/core/configs/configs.dart';
import 'package:mysite/core/res/responsive_size.dart';
import 'package:sizer/sizer.dart';
import 'widgets/animation_text.dart';

class HomeMobile extends StatelessWidget {
  const HomeMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(
        minHeight: (screenHeight - 80).clamp(600.0, 950.0),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const EntranceFader(
            offset: Offset(0, 24),
            delay: Duration(milliseconds: 120),
            duration: Duration(milliseconds: 700),
            child: ZoomAnimations(size: 180),
          ),
          const SizedBox(height: 28),
          EntranceFader(
            offset: const Offset(0, 20),
            delay: const Duration(milliseconds: 240),
            duration: const Duration(milliseconds: 650),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  hellotag,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(width: 6),
                Image.asset(StaticImage.hi, height: 26),
              ],
            ),
          ),
          const SizedBox(height: 8),
          EntranceFader(
            offset: const Offset(0, 22),
            delay: const Duration(milliseconds: 340),
            duration: const Duration(milliseconds: 650),
            child: Text(
              yourname,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(height: 6),
          EntranceFader(
            offset: const Offset(0, 20),
            delay: const Duration(milliseconds: 440),
            duration: const Duration(milliseconds: 650),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "A ",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Flexible(
                  child: AnimatedTextKit(
                    animatedTexts: mobileList,
                    repeatForever: true,
                    isRepeatingAnimation: true,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          EntranceFader(
            offset: const Offset(0, 18),
            delay: const Duration(milliseconds: 540),
            duration: const Duration(milliseconds: 650),
            child: Text(
              miniDescription,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: theme.textColor.withOpacity(0.7),
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 24),
          EntranceFader(
            offset: const Offset(0, 16),
            delay: const Duration(milliseconds: 640),
            duration: const Duration(milliseconds: 650),
            child: ColorChageButton(
              text: 'Download CV',
              onTap: () {
                downloadCV();
              },
            ),
          ),
        ],
      ),
    );
  }
}
