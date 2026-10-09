import 'package:flutter/material.dart';
import 'package:mysite/app/utils/contact_utils.dart';
import 'package:mysite/app/widgets/custom_text_heading.dart';
import 'package:mysite/changes/links.dart';
import 'package:mysite/changes/strings.dart';
import 'package:mysite/core/color/colors.dart';
import 'package:mysite/core/configs/configs.dart';
import 'package:mysite/core/util/constants.dart';
import 'package:sizer/sizer.dart';

class ContactDesktop extends StatelessWidget {
  const ContactDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;
    return Container(
      // padding: Space.all(1, 1),
      // padding: EdgeInsets.symmetric(horizontal: AppDimensions.normalize(30)),
      padding: EdgeInsets.symmetric(horizontal: size.width / 8),
      child: Column(
        children: [
          const CustomSectionHeading(text: "\nGet in Touch"),
          Space.y(1.w)!,
          const CustomSectionSubHeading(
            text:
                "If you want to avail my services you can contact me at the links below.",
          ),
          Space.y(2.w)!,
          Container(
            padding: EdgeInsets.all(size.width * 0.05).copyWith(bottom: 10),
            decoration: BoxDecoration(
              gradient: theme.contactCard,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [blackColorShadow],
            ),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              contactHeadding,
                              style: const TextStyle(
                                height: 1.2,
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              contactSubHeadding,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: theme.textColor.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => openURL(whatsapp),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 28),
                        decoration: BoxDecoration(
                            gradient: buttonGradi,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(color: Colors.white.withOpacity(0.15), height: 1),
                const SizedBox(height: 24),
                Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 16,
                    runSpacing: 16,
                    children: contactUtils
                        .map((e) => IconButton(
                              icon: Image.network(
                                e.icon,
                                width: 24,
                                height: 24,
                                color: theme.textColor,
                                errorBuilder: (ctx, err, stack) => Icon(
                                  Icons.open_in_new,
                                  size: 22,
                                  color: theme.textColor,
                                ),
                              ),
                              onPressed: () => openURL(e.url),
                              highlightColor: Colors.white24,
                            ))
                        .toList()),
              ],
            ),
          ),
          // Space.y!,
        ],
      ),
    );
  }
}
