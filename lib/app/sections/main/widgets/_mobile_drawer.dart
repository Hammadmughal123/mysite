part of '../main_section.dart';

class _MobileDrawer extends StatelessWidget {
  const _MobileDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollProvider = Provider.of<ScrollProvider>(context);
    // theme
    var theme = Theme.of(context);
    return Drawer(
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return Material(
            color: theme.scaffoldBackgroundColor,
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Column(
                  children: [
                    const Center(child: NavBarLogo()),
                    const SizedBox(height: 12),
                    const Divider(),
                    ListTile(
                      leading: Icon(
                        state.isDarkThemeOn
                            ? Icons.dark_mode_outlined
                            : Icons.light_mode,
                      ),
                      title:
                          Text(state.isDarkThemeOn ? "Dark Mode" : "Light Mode"),
                      trailing: Switch(
                        value: state.isDarkThemeOn,
                        activeColor: theme.primaryColor,
                        inactiveTrackColor: Colors.grey,
                        onChanged: (newValue) {
                          context.read<ThemeCubit>().updateTheme(newValue);
                        },
                      ),
                    ),
                    const Divider(),
                    ...NavBarUtils.names.asMap().entries.map(
                          (e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hoverColor: theme.primaryColor.withAlpha(70),
                              onTap: () {
                                scrollProvider.jumpTo(e.key);
                                Navigator.pop(context);
                              },
                              leading: Icon(
                                NavBarUtils.icons[e.key],
                                color: theme.primaryColor,
                              ),
                              title: Text(
                                e.value,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                    const SizedBox(height: 20),
                    ColorChageButton(
                      text: 'RESUME',
                      onTap: () {
                        downloadCV();
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
