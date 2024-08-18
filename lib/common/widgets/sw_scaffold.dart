import 'package:flutter/material.dart';
import 'package:sketch_wizards/common/widgets/sw_icon_button.dart';
import 'package:sketch_wizards/theme/sw_theme.dart';

class SWScaffold extends StatelessWidget {
  SWScaffold({
    super.key,
    this.title,
    this.action,
    this.showBackButton = false,
    this.bottomWidget,
    this.scrollable = true,
    this.showFloatingActionButton = false,
    required this.children,
  });

  final String? title;
  final Widget? action;
  final bool showBackButton;
  final List<Widget> children;
  final Widget? bottomWidget;
  final bool scrollable;
  final bool showFloatingActionButton;

  final ScrollController _scrollController = ScrollController();
  final double _scrollStep = 200.0; // Define the scroll step

  void _scrollUp() {
    final newOffset = (_scrollController.offset - _scrollStep).clamp(
      _scrollController.position.minScrollExtent,
      _scrollController.position.maxScrollExtent,
    );
    _scrollController.animateTo(
      newOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInQuad,
    );
  }

  void _scrollDown() {
    final newOffset = (_scrollController.offset + _scrollStep).clamp(
      _scrollController.position.minScrollExtent,
      _scrollController.position.maxScrollExtent,
    );
    _scrollController.animateTo(
      newOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInQuad,
    );
  }

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
                      style: SWTheme.regularTextStyle.copyWith(fontSize: 50),
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
            child: (!scrollable)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ...children,
                      if (bottomWidget != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 50),
                          child: bottomWidget!,
                        ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                          child: CustomScrollView(
                        controller: _scrollController,
                        slivers: [
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: Column(
                              children: children,
                            ),
                          ),
                        ],
                      )),
                      if (bottomWidget != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 50),
                          child: bottomWidget!,
                        ),
                    ],
                  ),
          ),
        ),
        floatingActionButton: showFloatingActionButton
            ? Padding(
                padding: const EdgeInsets.only(right: 20, top: 60 ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SWIconButton(
                      onPressed: _scrollUp,
                      icon: Icons.arrow_upward,
                    ),
                    const SizedBox(height: 75),
                    SWIconButton(
                        onPressed: _scrollDown, icon: Icons.arrow_downward),
                  ],
                ),
              )
            : null,
      ),
    );
  }
}
