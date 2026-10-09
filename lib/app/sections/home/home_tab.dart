import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:mysite/app/sections/home/widgets/animation_text.dart';
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

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(minHeight: height.clamp(680.0, 1100.0)),
      padding: EdgeInsets.symmetric(
        horizontal: (width * 0.06).clamp(24.0, 60.0),
        vertical: 40,
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EntranceFader(
                      offset: const Offset(0, 22),
                      delay: const Duration(milliseconds: 140),
                      duration: const Duration(milliseconds: 650),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            hellotag,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Image.asset(StaticImage.hi, height: 28),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    EntranceFader(
                      offset: const Offset(0, 24),
                      delay: const Duration(milliseconds: 240),
                      duration: const Duration(milliseconds: 700),
                      child: Text(
                        yourname,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    EntranceFader(
                      offset: const Offset(0, 20),
                      delay: const Duration(milliseconds: 360),
                      duration: const Duration(milliseconds: 700),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "A ",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Flexible(
                            child: AnimatedTextKit(
                              animatedTexts: tabList,
                              isRepeatingAnimation: true,
                              repeatForever: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    EntranceFader(
                      offset: const Offset(0, 20),
                      delay: const Duration(milliseconds: 480),
                      duration: const Duration(milliseconds: 700),
                      child: Text(
                        miniDescription,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: theme.textColor.withOpacity(0.7),
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    EntranceFader(
                      offset: const Offset(0, 16),
                      delay: const Duration(milliseconds: 580),
                      duration: const Duration(milliseconds: 700),
                      child: ColorChageButton(
                        text: 'Download CV',
                        onTap: () {
                          downloadCV();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const EntranceFader(
              offset: Offset(30, 0),
              delay: Duration(milliseconds: 280),
              duration: Duration(milliseconds: 800),
              child: ZoomAnimations(size: 210),
            ),
          ],
        ),
      ),
    );
  }
}
