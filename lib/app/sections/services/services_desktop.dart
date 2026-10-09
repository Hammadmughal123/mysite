part of 'services.dart';

class ServiceDesktop extends StatefulWidget {
  const ServiceDesktop({Key? key}) : super(key: key);

  @override
  ServiceDesktopState createState() => ServiceDesktopState();
}

class ServiceDesktopState extends State<ServiceDesktop> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: (width * 0.06).clamp(24.0, 100.0),
        vertical: 40,
      ),
      child: Column(
        children: [
          const ScrollReveal(
            detectorKey: 'services-heading',
            child: CustomSectionHeading(text: '\nWhat I can do?'),
          ),
          Space.y(1.w)!,
          ScrollReveal(
            detectorKey: 'services-subheading',
            delay: const Duration(milliseconds: 80),
            child: CustomSectionSubHeading(text: servicesSubHeading),
          ),
          Space.y(3.w)!,
          LayoutBuilder(
            builder: (context, constraints) {
              final double availableWidth = constraints.maxWidth;
              if (availableWidth >= 1200) {
                final double cardWidth =
                    ((availableWidth - (3 * 20)) / 4).clamp(260.0, 310.0);
                return Wrap(
                  spacing: 20,
                  runSpacing: 24,
                  alignment: WrapAlignment.center,
                  children: servicesUtils.asMap().entries.map((e) {
                    // Left cards come from left, right cards come from right
                    final double slideX = e.key == 0
                        ? -65.0
                        : e.key == 1
                            ? -35.0
                            : e.key == 2
                                ? 35.0
                                : 65.0;
                    return ScrollReveal(
                      detectorKey: 'service-${e.key}',
                      duration: const Duration(milliseconds: 1050),
                      delay: Duration(milliseconds: 120 + e.key * 100),
                      beginOffset: Offset(slideX, 26),
                      child: _ServiceCard(
                        service: e.value,
                        cardWidth: cardWidth,
                        cardHeight: 360,
                      ),
                    );
                  }).toList(),
                );
              } else {
                final double cardWidth =
                    ((availableWidth - 24) / 2).clamp(280.0, 420.0);
                return Wrap(
                  spacing: 24,
                  runSpacing: 24,
                  alignment: WrapAlignment.center,
                  children: servicesUtils.asMap().entries.map((e) {
                    final bool fromRight = e.key % 2 != 0;
                    return ScrollReveal(
                      detectorKey: 'service-md-${e.key}',
                      duration: const Duration(milliseconds: 1050),
                      delay: Duration(milliseconds: 120 + e.key * 100),
                      beginOffset: Offset(fromRight ? 55.0 : -55.0, 26),
                      child: _ServiceCard(
                        service: e.value,
                        cardWidth: cardWidth,
                        cardHeight: 360,
                      ),
                    );
                  }).toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
