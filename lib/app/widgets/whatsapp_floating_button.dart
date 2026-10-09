import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mysite/changes/links.dart';
import 'package:mysite/core/util/constants.dart';

class WhatsAppFloatingButton extends StatefulWidget {
  const WhatsAppFloatingButton({Key? key}) : super(key: key);

  @override
  State<WhatsAppFloatingButton> createState() => _WhatsAppFloatingButtonState();
}

class _WhatsAppFloatingButtonState extends State<WhatsAppFloatingButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  // Crisp WhatsApp SVG vector icon
  static const String _whatsappSvg = '''
<svg viewBox="0 0 24 24" width="28" height="28" fill="white">
  <path d="M12.04 2c-5.46 0-9.91 4.45-9.91 9.91 0 1.75.46 3.45 1.32 4.95L2.05 22l5.25-1.38c1.45.79 3.08 1.21 4.74 1.21 5.46 0 9.91-4.45 9.91-9.91 0-2.65-1.03-5.14-2.9-7.01A9.816 9.816 0 0 0 12.04 2m.01 1.67c2.2 0 4.26.86 5.82 2.42a8.225 8.225 0 0 1 2.41 5.83c0 4.54-3.7 8.24-8.24 8.24-1.48 0-2.93-.4-4.2-1.15l-.3-.18-3.12.82.83-3.04-.2-.31a8.19 8.19 0 0 1-1.26-4.38c0-4.54 3.7-8.24 8.24-8.24m4.52 11.66c-.25-.13-1.47-.72-1.7-.81-.23-.08-.39-.13-.56.13-.17.25-.64.81-.79.97-.14.17-.29.19-.54.06-.25-.13-1.06-.39-2.02-1.25-.75-.67-1.26-1.5-1.41-1.75-.14-.25-.02-.39.11-.51.11-.11.25-.29.37-.44.13-.14.17-.25.25-.42.08-.17.04-.31-.02-.44-.06-.13-.56-1.35-.77-1.85-.2-.49-.41-.42-.56-.43h-.48c-.17 0-.44.06-.67.31-.23.25-.88.86-.88 2.1s.9 2.44 1.03 2.61c.13.17 1.77 2.7 4.28 3.79.6.26 1.07.41 1.43.53.6.19 1.15.16 1.58.1.48-.07 1.47-.6 1.68-1.18.21-.58.21-1.07.15-1.18-.06-.1-.23-.17-.48-.3z"/>
</svg>
''';

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24,
      right: 24,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            final scale = _isHovered ? 1.12 : _pulseAnimation.value;
            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: Tooltip(
            message: 'Chat on WhatsApp',
            child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => openURL(whatsapp),
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF25D366),
                        Color(0xFF128C7E),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF25D366).withOpacity(_isHovered ? 0.6 : 0.4),
                        blurRadius: _isHovered ? 20 : 14,
                        spreadRadius: _isHovered ? 4 : 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: SvgPicture.string(
                      _whatsappSvg,
                      width: 30,
                      height: 30,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
