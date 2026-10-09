part of '../services.dart';

class _ServiceCard extends StatefulWidget {
  final ServicesUtils service;
  final double cardWidth;
  final double cardHeight;

  const _ServiceCard({
    Key? key,
    required this.service,
    this.cardWidth = 300,
    this.cardHeight = 380,
  }) : super(key: key);

  @override
  _ServiceCardState createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => isHover = true),
      onExit: (_) => setState(() => isHover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        width: widget.cardWidth,
        height: widget.cardHeight,
        transform: Matrix4.identity()..translate(0.0, isHover ? -8.0 : 0.0),
        padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 22.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isHover
                ? [
                    const Color(0xFF232138),
                    const Color(0xFF151425),
                  ]
                : [
                    const Color(0xFF1B1A2A),
                    const Color(0xFF11101C),
                  ],
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isHover
                ? primaryColor.withOpacity(0.7)
                : Colors.white.withOpacity(0.08),
            width: 1.5,
          ),
          boxShadow: isHover
              ? [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.22),
                    blurRadius: 24,
                    spreadRadius: 1,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: secondaryColor.withOpacity(0.12),
                    blurRadius: 32,
                    offset: const Offset(0, 12),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top: Icon Squircle
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 66,
              height: 66,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isHover
                      ? [
                          primaryColor.withOpacity(0.25),
                          secondaryColor.withOpacity(0.2),
                        ]
                      : [
                          primaryColor.withOpacity(0.12),
                          secondaryColor.withOpacity(0.06),
                        ],
                ),
                border: Border.all(
                  color: isHover
                      ? primaryColor.withOpacity(0.85)
                      : primaryColor.withOpacity(0.25),
                  width: 1.5,
                ),
                boxShadow: isHover
                    ? [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.35),
                          blurRadius: 18,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: widget.service.icon.endsWith('.png')
                  ? Image.asset(widget.service.icon, fit: BoxFit.contain)
                  : SvgPicture.asset(widget.service.icon, fit: BoxFit.contain),
            ),
            const SizedBox(height: 18),
            // Title
            Text(
              widget.service.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.3,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 12),
            // Description
            Text(
              widget.service.description,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontWeight: FontWeight.w400,
                fontSize: 13,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 18),
            // Divider
            Container(
              height: 1.5,
              width: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryColor.withOpacity(0.6),
                    secondaryColor.withOpacity(0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            const SizedBox(height: 18),
            // Tools pills
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: widget.service.tool.map((tool) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isHover
                        ? primaryColor.withOpacity(0.15)
                        : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isHover
                          ? primaryColor.withOpacity(0.6)
                          : Colors.white.withOpacity(0.12),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    tool,
                    style: TextStyle(
                      color: isHover ? primaryColor : Colors.white.withOpacity(0.85),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}



