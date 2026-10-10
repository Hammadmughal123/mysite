import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mysite/app/utils/contact_utils.dart';
import 'package:mysite/core/util/constants.dart';

class SocialIconButton extends StatefulWidget {
  final ContactUtils item;
  final double size;

  const SocialIconButton({
    super.key,
    required this.item,
    this.size = 46,
  });

  @override
  State<SocialIconButton> createState() => _SocialIconButtonState();
}

class _SocialIconButtonState extends State<SocialIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: Tooltip(
        message: item.name,
        waitDuration: const Duration(milliseconds: 300),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          transform: _isHovered
              // ignore: deprecated_member_use
              ? (Matrix4.identity()..translate(0.0, -3.0, 0.0))
              : Matrix4.identity(),
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: _isHovered
                ? item.brandColor.withValues(alpha: 0.22)
                : Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _isHovered
                  ? item.brandColor.withValues(alpha: 0.85)
                  : Colors.white.withValues(alpha: 0.12),
              width: 1.5,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: item.brandColor.withValues(alpha: 0.4),
                      blurRadius: 14,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => openURL(item.url),
              child: Center(
                child: SvgPicture.string(
                  item.svg,
                  width: widget.size * 0.48,
                  height: widget.size * 0.48,
                  colorFilter: ColorFilter.mode(
                    _isHovered ? Colors.white : Colors.white.withValues(alpha: 0.88),
                    BlendMode.srcIn,
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
