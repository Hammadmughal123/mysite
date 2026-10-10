import 'package:flutter/material.dart';
import 'package:mysite/core/color/colors.dart';
import 'package:mysite/core/providers/scroll_provider.dart';
import 'package:provider/provider.dart';

class ArrowOnTop extends StatefulWidget {
  const ArrowOnTop({super.key});

  @override
  ArrowOnTopState createState() => ArrowOnTopState();
}

class ArrowOnTopState extends State<ArrowOnTop> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    final scrollProvider = Provider.of<ScrollProvider>(context);

    return Positioned(
      bottom: 92,
      right: 28,
      child: Tooltip(
        message: 'Back to Top',
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => scrollProvider.jumpTo(0),
            onHover: (isHovering) {
              if (isHovering != isHover) {
                setState(() => isHover = isHovering);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isHover ? buttonGradi : pinkpurple,
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withValues(alpha: isHover ? 0.6 : 0.3),
                    blurRadius: isHover ? 16 : 8,
                    spreadRadius: isHover ? 2 : 0,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.keyboard_arrow_up_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
