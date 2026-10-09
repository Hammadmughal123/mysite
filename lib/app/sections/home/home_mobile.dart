import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:mysite/app/sections/services/services.dart';
import 'package:mysite/app/widgets/color_chage_btn.dart';
import 'package:mysite/changes/img.dart';
import 'package:mysite/changes/links.dart';
import 'package:mysite/changes/strings.dart';
import 'package:mysite/core/animations/entrance_fader.dart';
import 'package:mysite/core/animations/zoom_animation.dart';
import 'package:mysite/core/configs/configs.dart';
import 'package:mysite/core/res/responsive_size.dart';
import 'package:sizer/sizer.dart';
import 'package:universal_html/html.dart' as html;

import 'widgets/animation_text.dart';

class HomeMobile extends StatelessWidget {
  const HomeMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const EntranceFader(
            offset: Offset(0, -20),
            delay: Duration(milliseconds: 400),
            duration: Duration(milliseconds: 800),
            child: ZoomAnimations(size: 180),
          ),
          const SizedBox(height: 28),
          Row(
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
          const SizedBox(height: 8),
          Text(
            yourname,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Row(
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
          const SizedBox(height: 14),
          Text(
            miniDescription,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: theme.textColor.withOpacity(0.7),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          ColorChageButton(
            text: 'Download CV',
            onTap: () {
              downloadCV();
            },
          ),
        ],
      ),
    );
  }
}
