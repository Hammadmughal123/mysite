import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mysite/core/providers/scroll_provider.dart';

/// Scope that propagates the visibility state of a section to all its child components.
class SectionVisibilityScope extends InheritedWidget {
  final bool isVisible;
  final int sectionIndex;

  const SectionVisibilityScope({
    super.key,
    required this.isVisible,
    required this.sectionIndex,
    required super.child,
  });

  static bool of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<SectionVisibilityScope>();
    return scope?.isVisible ?? true;
  }

  static int? indexOf(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<SectionVisibilityScope>();
    return scope?.sectionIndex;
  }

  @override
  bool updateShouldNotify(SectionVisibilityScope oldWidget) {
    return isVisible != oldWidget.isVisible ||
        sectionIndex != oldWidget.sectionIndex;
  }
}

class ScrollEntranceSection extends StatelessWidget {
  final Widget child;
  final int index;

  const ScrollEntranceSection({
    super.key,
    required this.child,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    if (index == 0) {
      return SectionVisibilityScope(
        isVisible: true,
        sectionIndex: 0,
        child: child,
      );
    }

    final scrollProvider = Provider.of<ScrollProvider>(context);
    final bool isVisible = scrollProvider.isSectionVisible(index);

    return SectionVisibilityScope(
      isVisible: isVisible,
      sectionIndex: index,
      child: child,
    );
  }
}
