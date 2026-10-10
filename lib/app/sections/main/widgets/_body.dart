part of '../main_section.dart';

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scrollProvider = Provider.of<ScrollProvider>(context);
    final isMobile = Responsive.isMobile(context);

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        scrollbars: false,
        overscroll: false,
      ),
      child: ScrollablePositionedList.builder(
        physics: const ClampingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: EdgeInsets.zero,
        addAutomaticKeepAlives: true,
        addRepaintBoundaries: true,
        // Moderate cache extent to balance smoothness without exhausting mobile memory
        minCacheExtent: isMobile ? 400 : 800,
        itemCount: BodyUtils.views.length,
        itemBuilder: (context, index) => ScrollEntranceSection(
          index: index,
          child: BodyUtils.views[index],
        ),
        itemScrollController: scrollProvider.itemScrollController,
        itemPositionsListener: scrollProvider.itemPositionsListener,
      ),
    );
  }
}
