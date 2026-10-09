import 'package:flutter/cupertino.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ScrollProvider extends ChangeNotifier {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  final Duration scrollDuration = const Duration(milliseconds: 800);

  final Set<int> _visibleIndices = {0};
  Set<int> get visibleIndices => _visibleIndices;

  ScrollProvider() {
    itemPositionsListener.itemPositions.addListener(_onPositionsChanged);
  }

  void _onPositionsChanged() {
    final positions = itemPositionsListener.itemPositions.value;
    bool updated = false;
    for (final pos in positions) {
      // If any portion of the item is within or near the visible viewport
      if (pos.itemLeadingEdge < 0.95 && pos.itemTrailingEdge > 0.05) {
        if (_visibleIndices.add(pos.index)) {
          updated = true;
        }
      }
    }
    if (updated) {
      notifyListeners();
    }
  }

  bool isVisible(int index) => _visibleIndices.contains(index);

  void markVisible(int index) {
    if (_visibleIndices.add(index)) {
      notifyListeners();
    }
  }

  void jumpTo(int index) {
    _visibleIndices.add(index);
    notifyListeners();
    if (itemScrollController.isAttached) {
      itemScrollController.scrollTo(
        index: index,
        duration: scrollDuration,
        curve: Curves.easeInOutCubic,
        alignment: 0,
      );
    }
  }

  @override
  void dispose() {
    itemPositionsListener.itemPositions.removeListener(_onPositionsChanged);
    super.dispose();
  }
}
