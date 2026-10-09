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
          const CustomSectionHeading(text: '\nWhat I can do?'),
          Space.y(1.w)!,
          CustomSectionSubHeading(text: servicesSubHeading),
          Space.y(3.w)!,
          LayoutBuilder(
            builder: (context, constraints) {
              final double availableWidth = constraints.maxWidth;
              if (availableWidth >= 1200) {
                // 4 columns across on wide screens
                final double cardWidth =
                    ((availableWidth - (3 * 20)) / 4).clamp(260.0, 310.0);
                return Wrap(
                  spacing: 20,
                  runSpacing: 24,
                  alignment: WrapAlignment.center,
                  children: servicesUtils.asMap().entries.map((e) {
                    return _ServiceCard(
                      service: e.value,
                      cardWidth: cardWidth,
                      cardHeight: 360,
                    )
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
                        );
                  }).toList(),
                );
              } else {
                // 2x2 symmetrical grid on medium desktop / laptop
                final double cardWidth =
                    ((availableWidth - 24) / 2).clamp(280.0, 420.0);
                return Wrap(
                  spacing: 24,
                  runSpacing: 24,
                  alignment: WrapAlignment.center,
                  children: servicesUtils.asMap().entries.map((e) {
                    return _ServiceCard(
                      service: e.value,
                      cardWidth: cardWidth,
                      cardHeight: 360,
                    )
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
