import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mysite/app/utils/project_utils.dart';
import 'package:mysite/app/widgets/custom_text_heading.dart';
import 'package:mysite/changes/links.dart';
import 'package:mysite/changes/strings.dart';
import 'package:mysite/core/configs/configs.dart';
import 'package:mysite/core/util/constants.dart';
import 'package:sizer/sizer.dart';

import 'widgets/project_card.dart';

class PortfolioDesktop extends StatefulWidget {
  const PortfolioDesktop({Key? key}) : super(key: key);

  @override
  State<PortfolioDesktop> createState() => _PortfolioDesktopState();
}

class _PortfolioDesktopState extends State<PortfolioDesktop> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double horizontalPadding =
        (size.width * 0.06).clamp(24.0, 100.0);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 30),
      child: Column(
        children: [
          const CustomSectionHeading(text: "\nProjects"),
          Space.y(1.w)!,
          CustomSectionSubHeading(text: protfolioSubHeading),
          Space.y(2.w)!,
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 20,
            children: projectUtils
                .asMap()
                .entries
                .map(
                  (e) => ProjectCard(project: e.value)
                      .animate(delay: (e.key * 100).ms)
                      .fadeIn(duration: 500.ms, curve: Curves.easeOutCubic)
                      .slideY(
                          begin: 0.18,
                          end: 0,
                          duration: 500.ms,
                          curve: Curves.easeOutCubic)
                      .scale(
                        begin: const Offset(0.95, 0.95),
                        end: const Offset(1, 1),
                        curve: Curves.easeOutCubic,
                      ),
                )
                .toList(),
          ),
          Space.y(3.w)!,
          OutlinedButton(
            onPressed: () => openURL(gitHub),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'See More',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
