
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysite/app/widgets/arrow_on_top.dart';
import 'package:mysite/app/widgets/whatsapp_floating_button.dart';
import 'package:mysite/app/widgets/color_chage_btn.dart';
// import 'package:mysite/changes/links.dart';
import 'package:mysite/core/color/colors.dart';
import 'package:mysite/core/configs/app.dart';
import 'package:mysite/core/configs/configs.dart';
import 'package:mysite/core/providers/drawer_provider.dart';
import 'package:mysite/core/providers/scroll_provider.dart';
import 'package:mysite/app/utils/navbar_utils.dart';
import 'package:mysite/app/utils/utils.dart';
import 'package:mysite/app/widgets/navbar_actions_button.dart';
import 'package:mysite/app/widgets/navbar_logo.dart';
import 'package:mysite/core/res/responsive.dart';
import 'package:mysite/core/theme/cubit/theme_cubit.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
// import 'package:mysite/core/util/constants.dart';
import 'package:sizer/sizer.dart';
import 'package:mysite/core/animations/particle_field.dart';
import 'package:mysite/core/animations/scroll_entrance_section.dart';
import 'package:mysite/app/utils/cv/download_cv.dart';
// import '../services/services.dart';
part 'widgets/_navbar_desktop.dart';
part 'widgets/_mobile_drawer.dart';
part 'widgets/_body.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final drawerProvider = Provider.of<DrawerProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: drawerProvider.key,
      extendBodyBehindAppBar: true,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Responsive(
          desktop: _NavbarDesktop(),
          mobile: _NavBarTablet(),
          tablet: _NavBarTablet(),
        ),
      ),
      drawer: !Responsive.isDesktop(context) ? const _MobileDrawer() : null,
      body: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return Stack(
            children: [
              const Positioned.fill(child: ParticleField()),
              // GPU-optimized glowing gradient orb (top-left)
              Positioned(
                top: height * 0.15,
                left: -100,
                child: RepaintBoundary(
                  child: IgnorePointer(
                    child: Container(
                      height: 380,
                      width: 380,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            secondaryColor.withValues(alpha: 0.35),
                            secondaryColor.withValues(alpha: 0.12),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.45, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // GPU-optimized glowing gradient orb (bottom-right)
              Positioned(
                bottom: -50,
                right: -100,
                child: RepaintBoundary(
                  child: IgnorePointer(
                    child: Container(
                      height: 420,
                      width: 420,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            primaryColor.withValues(alpha: 0.35),
                            primaryColor.withValues(alpha: 0.12),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.45, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (!state.isDarkThemeOn)
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/imgs/5424482.jpg',
                    cacheWidth: 1200,
                    opacity: const AlwaysStoppedAnimation<double>(0.2),
                    width: width,
                    height: height,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
              RepaintBoundary(child: _Body()),
              const ArrowOnTop(),
              const WhatsAppFloatingButton(),
            ],
          );
        },
      ),
    );
  }
}
