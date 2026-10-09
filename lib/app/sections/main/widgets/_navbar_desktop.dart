part of '../main_section.dart';

class _NavbarDesktop extends StatefulWidget {
  const _NavbarDesktop({Key? key}) : super(key: key);

  @override
  State<_NavbarDesktop> createState() => _NavbarDesktopState();
}

class _NavbarDesktopState extends State<_NavbarDesktop> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var theme = Theme.of(context);
    final double horizontalPadding =
        (size.width * 0.05).clamp(24.0, 80.0);

    return BlocBuilder<ThemeCubit, ThemeState>(builder: (context, state) {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 12,
        ),
        color: theme.navBarColor,
        child: Row(
          children: [
            const NavBarLogo(),
            const Spacer(),
            ...NavBarUtils.names.asMap().entries.map(
                  (e) => NavBarActionButton(
                    label: e.value,
                    index: e.key,
                  ),
                ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: state.isDarkThemeOn ? 'Light Mode' : 'Dark Mode',
              onPressed: () {
                context.read<ThemeCubit>().updateTheme(!state.isDarkThemeOn);
              },
              icon: Icon(
                state.isDarkThemeOn
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
                color: state.isDarkThemeOn
                    ? Colors.amber.shade400
                    : Colors.indigo.shade300,
                size: 22,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _NavBarTablet extends StatelessWidget {
  const _NavBarTablet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final drawerProvider = Provider.of<DrawerProvider>(context);
    var theme = Theme.of(context);
    return Container(
      color: theme.navBarColor,
      padding: EdgeInsets.symmetric(
          horizontal: Responsive.isTablet(context) ? 10.w : 10, vertical: 10),
      child: Row(
        children: [
          IconButton(
            highlightColor: Colors.white54,
            onPressed: () {
              drawerProvider.key.currentState!.openDrawer();
            },
            icon: const Icon(Icons.menu),
          ),
          Space.xm!,
          const NavBarLogo(),
          // Space.x1!,
        ],
      ),
    );
  }
}
