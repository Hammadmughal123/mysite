import 'package:flutter/cupertino.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ScrollProvider extends ChangeNotifier {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final Duration scrollDuration = const Duration(milliseconds: 900);

  final Set<int> _visibleIndices = {0};
  Set<int> get visibleIndices => _visibleIndices;

  ScrollProvider() {
    itemPositionsListener.itemPositions.addListener(_onPositionsChanged);
  }

  void _onPositionsChanged() {
    final positions = itemPositionsListener.itemPositions.value;
    bool updated = false;
    final Set<int> newlyVisible = {};

    for (final pos in positions) {
      // Section in view when leading edge hasn't gone too far up and trailing edge is on screen
      if (pos.itemLeadingEdge < 0.85 && pos.itemTrailingEdge > 0.0) {
        newlyVisible.add(pos.index);
      }
    }

    if (newlyVisible.isEmpty) {
      newlyVisible.add(0);
    }

    for (int i = 0; i <= 6; i++) {
      final bool nowVisible = newlyVisible.contains(i);
      final bool wasVisible = _visibleIndices.contains(i);
      if (nowVisible != wasVisible) {
        if (nowVisible) {
          _visibleIndices.add(i);
        } else {
          _visibleIndices.remove(i);
        }
        updated = true;
      }
    }

    if (updated) {
      notifyListeners();
    }
  }

  bool isVisible(int index) => _visibleIndices.contains(index);

  bool isSectionVisible(int index) => _visibleIndices.contains(index);

  void markVisible(int index) {
    if (_visibleIndices.add(index)) {
      notifyListeners();
    }
  }

  void jumpTo(int index) {
    _visibleIndices.remove(index);
    notifyListeners();

    if (itemScrollController.isAttached) {
      itemScrollController.scrollTo(
        index: index,
        duration: scrollDuration,
        curve: Curves.easeInOutCubic,
        alignment: 0,
      );
    }

    Future.delayed(const Duration(milliseconds: 550), () {
      if (!_visibleIndices.contains(index)) {
        _visibleIndices.add(index);
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    itemPositionsListener.itemPositions.removeListener(_onPositionsChanged);
    super.dispose();
  }
}
