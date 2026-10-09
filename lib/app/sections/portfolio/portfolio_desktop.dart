import 'package:flutter/material.dart';
import 'package:mysite/app/utils/project_utils.dart';
import 'package:mysite/app/widgets/custom_text_heading.dart';
import 'package:mysite/changes/links.dart';
import 'package:mysite/changes/strings.dart';
import 'package:mysite/core/animations/scroll_reveal.dart';
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
          const ScrollReveal(
            detectorKey: 'projects-heading',
            child: CustomSectionHeading(text: "\nProjects"),
          ),
          Space.y(1.w)!,
          ScrollReveal(
            detectorKey: 'projects-subheading',
            delay: const Duration(milliseconds: 80),
            child: CustomSectionSubHeading(text: protfolioSubHeading),
          ),
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
                  (e) {
                    final bool fromRight = e.key % 2 != 0;
                    return ScrollReveal(
                      detectorKey: 'project-${e.key}',
                      duration: const Duration(milliseconds: 1050),
                      delay: Duration(milliseconds: 120 + e.key * 100),
                      beginOffset: Offset(fromRight ? 55.0 : -55.0, 24),
                      child: ProjectCard(project: e.value),
                    );
                  },
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
