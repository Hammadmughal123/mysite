import 'package:flutter/material.dart';
import 'package:mysite/app/widgets/custom_outline.dart';
import 'package:mysite/core/theme/app_theme.dart';

class ZoomAnimations extends StatefulWidget {
  final double? size;
  const ZoomAnimations({Key? key, this.size}) : super(key: key);

  @override
  State<ZoomAnimations> createState() => _ZoomAnimationsState();
}

class _ZoomAnimationsState extends State<ZoomAnimations>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _controller2;
  late final Animation<AlignmentGeometry> _alignAnimation;
  late Animation<double> sizeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    sizeAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );
    _controller.forward();

    _controller2 = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    _alignAnimation = Tween<AlignmentGeometry>(
      begin: const Alignment(0, -0.06),
      end: const Alignment(0, 0.06),
    ).animate(
      CurvedAnimation(
        parent: _controller2,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    var theme = Theme.of(context);
    final double avatarSize = widget.size ??
        (screenSize.width * 0.22).clamp(200.0, 320.0);

    return SizedBox(
      width: avatarSize + 20,
      height: avatarSize + 20,
      child: AlignTransition(
        alignment: _alignAnimation,
        child: AnimatedBuilder(
          animation: sizeAnimation,
          builder: (context, child) {
            final double currentSize = avatarSize * sizeAnimation.value;
            return CustomOutline(
              strokeWidth: 4,
              radius: currentSize / 2,
              padding: const EdgeInsets.all(4),
              width: currentSize,
              height: currentSize,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.secondaryColor,
                  theme.secondaryColor.withOpacity(0.3),
                  theme.primaryColor.withOpacity(0.3),
                  theme.primaryColor,
                ],
                stops: const [0.1, 0.4, 0.7, 1.0],
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.8),
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    image: AssetImage('assets/imgs/IMG_0107.jpeg'),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
