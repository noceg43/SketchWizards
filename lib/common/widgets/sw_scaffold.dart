import 'package:flutter/material.dart';
import 'package:sketch_wizards/common/widgets/sw_icon_button.dart';
import 'package:sketch_wizards/theme/sw_theme.dart';

class SWScaffold extends StatelessWidget {
  const SWScaffold({
    super.key,
    this.title,
    this.action,
    this.showBackButton = false,
    this.bottomWidget,
    required this.children,
  });

  final String? title;

  final Widget? action;
  final bool showBackButton;

  final List<Widget> children;

  final Widget? bottomWidget;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 150,
          automaticallyImplyLeading: false,
          leadingWidth: 170,
          centerTitle: true,
          leading: showBackButton
              ? Padding(
                  padding: const EdgeInsets.only(left: 70, top: 50),
                  child: SWIconButton(
                    icon: Icons.arrow_back,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                )
              : null,
          title: title != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: AnimatedSwitcher(
                    transitionBuilder: (child, animation) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, -10),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    },
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      title!,
                      key: ValueKey(title),
                      style: SWTheme.regularTextStyle,
                    ),
                  ),
                )
              : null,
          actions: action != null
              ? [
                  Padding(
                    padding: const EdgeInsets.only(right: 70, top: 50),
                    child: Center(child: action!),
                  )
                ]
              : null,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: children,
                    ),
                  ),
                ),
                if (bottomWidget != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 50),
                    child: bottomWidget!,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
