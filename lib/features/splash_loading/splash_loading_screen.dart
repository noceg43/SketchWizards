import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sketch_wizards/common/service_locator/service_locator.dart';
import 'package:sketch_wizards/features/start_game/screens/sw_home.dart';
import 'package:sketch_wizards/theme/sw_theme.dart';

class SplashLoadingScreen extends StatefulWidget {
  const SplashLoadingScreen({super.key});

  @override
  State<SplashLoadingScreen> createState() => _SplashLoadingScreenState();
}

class _SplashLoadingScreenState extends State<SplashLoadingScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        await Future.delayed(const Duration(seconds: 3));
        await setupWizard();
        if (mounted) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const SWHome(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
                const end = Offset.zero;
                const curve = Curves.ease;
                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);
                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            ),
          );
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SWTheme.backgroundColor,
      child: Center(
        child: SizedBox(
          height: 300,
          child: AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child:
                  const Image(image: AssetImage('assets/images/app_icon.png')),
            ),
          ),
        )
            .animate()
            .shakeX(
              delay: 500.milliseconds,
              duration: 500.milliseconds,
              curve: Curves.easeInOut,
              amount: 0.5,
            )
            .animate(
          delay: 1.seconds,
          effects: [
            ScaleEffect(
              end: const Offset(1.5, 1.5),
              curve: Curves.easeInOut,
              duration: 2.seconds,
            ),
            ShakeEffect(
              duration: 2.seconds,
              curve: Curves.easeInOut,
              rotation: 0.05,
            ),
            SlideEffect(
              begin: Offset.zero,
              end: const Offset(-100, 0),
              delay: 2.seconds,
            ),
          ],
        ),
      ),
    );
  }
}
