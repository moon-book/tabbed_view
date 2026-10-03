import 'package:flutter/material.dart';

import 'internal/tabbed_view_delegate.dart';
import 'internal/tabbed_view_provider.dart';
import 'internal/tabbed_view_source.dart';
import 'internal/tabs_area/tabs_area.dart';
import 'tab_data.dart';
import 'tabbed_view.dart';
import 'tabbed_view_controller.dart';
import 'theme/tabbed_view_tab_bar_theme_data.dart';
import 'theme/tabbed_view_theme_data.dart';
import 'theme/theme_widget.dart';
import 'typedefs/can_drop.dart';
import 'typedefs/on_before_drop_accept.dart';
import 'typedefs/on_draggable_build.dart';
import 'typedefs/on_tab_close.dart';
import 'typedefs/on_tab_drag.dart';
import 'typedefs/on_tab_secondary_tap.dart';
import 'typedefs/on_tab_select.dart';
import 'typedefs/tab_remove_interceptor.dart';
import 'typedefs/tabs_area_buttons_builder.dart';
import 'unselected_tab_buttons_behavior.dart';

/// A standalone tab bar for a [TabbedViewController].
///
/// Place this widget anywhere in the layout and use a [TabbedView] with
/// `tabsAreaVisible: false` for the associated content area.
class TabbedViewTabBar extends StatefulWidget {
  static const bool _defaultTabReorderEnabled = true;
  static const UnselectedTabButtonsBehavior _defaultUnselectedBehavior =
      UnselectedTabButtonsBehavior.allDisabled;

  const TabbedViewTabBar._({
    super.key,
    required this.delegate,
    required this.theme,
    required this.tabReorderEnabled,
    required this.onTabSecondaryTap,
    required this.unselectedTabButtonsBehavior,
    required this.closeButtonTooltip,
    required this.tabsAreaButtonsBuilder,
    required this.onDraggableBuild,
    required this.canDrop,
    required this.onBeforeDropAccept,
    required this.dragScope,
    required this.tabRemoveInterceptor,
    required this.trailing,
  });

  /// Creates a controller-driven standalone tab bar.
  factory TabbedViewTabBar({
    Key? key,
    required TabbedViewController controller,
    TabbedViewTabBarThemeData? theme,
    bool? tabReorderEnabled,
    OnTabSecondaryTap? onTabSecondaryTap,
    UnselectedTabButtonsBehavior? unselectedTabButtonsBehavior,
    String? closeButtonTooltip,
    TabsAreaButtonsBuilder? tabsAreaButtonsBuilder,
    OnDraggableBuild? onDraggableBuild,
    CanDrop? canDrop,
    OnBeforeDropAccept? onBeforeDropAccept,
    String? dragScope,
    TabRemoveInterceptor? tabRemoveInterceptor,
    Widget? trailing,
  }) {
    return TabbedViewTabBar._(
      key: key,
      delegate: ImperativeTabbedViewDelegate(controller: controller),
      theme: theme ?? TabbedViewTabBarThemeData.classic(),
      tabReorderEnabled:
          tabReorderEnabled ?? _defaultTabReorderEnabled,
      onTabSecondaryTap: onTabSecondaryTap,
      unselectedTabButtonsBehavior:
          unselectedTabButtonsBehavior ?? _defaultUnselectedBehavior,
      closeButtonTooltip: closeButtonTooltip,
      tabsAreaButtonsBuilder: tabsAreaButtonsBuilder,
      onDraggableBuild: onDraggableBuild,
      canDrop: canDrop,
      onBeforeDropAccept: onBeforeDropAccept,
      dragScope: dragScope,
      tabRemoveInterceptor: tabRemoveInterceptor,
      trailing: trailing,
    );
  }

  /// Creates a standalone tab bar whose state is owned by the caller.
  ///
  /// All callbacks represent user intent. The caller must update [tabs] or
  /// [selectedTabId] and rebuild this widget to apply a requested operation.
  factory TabbedViewTabBar.declarative({
    Key? key,
    required List<TabData> tabs,
    Object? selectedTabId,
    OnTabClose? onTabClose,
    OnTabReorder? onTabReorder,
    OnTabDetach? onTabDetach,
    OnTabAttach? onTabAttach,
    OnTabSelect? onTabSelect,
    TabbedViewTabBarThemeData? theme,
    bool? tabReorderEnabled,
    OnTabSecondaryTap? onTabSecondaryTap,
    UnselectedTabButtonsBehavior? unselectedTabButtonsBehavior,
    String? closeButtonTooltip,
    TabsAreaButtonsBuilder? tabsAreaButtonsBuilder,
    OnDraggableBuild? onDraggableBuild,
    CanDrop? canDrop,
    OnBeforeDropAccept? onBeforeDropAccept,
    String? dragScope,
    TabRemoveInterceptor? tabRemoveInterceptor,
    Widget? trailing,
  }) {
    return TabbedViewTabBar._(
      key: key,
      delegate: DeclarativeTabbedViewDelegate(
        tabs: tabs,
        selectedTabId: selectedTabId,
        onTabClose: onTabClose,
        onTabReorder: onTabReorder,
        onTabAttach: onTabAttach,
        onTabDetach: onTabDetach,
        onTabSelect: onTabSelect,
      ),
      theme: theme ?? TabbedViewTabBarThemeData.classic(),
      tabReorderEnabled:
          tabReorderEnabled ?? _defaultTabReorderEnabled,
      onTabSecondaryTap: onTabSecondaryTap,
      unselectedTabButtonsBehavior:
          unselectedTabButtonsBehavior ?? _defaultUnselectedBehavior,
      closeButtonTooltip: closeButtonTooltip,
      tabsAreaButtonsBuilder: tabsAreaButtonsBuilder,
      onDraggableBuild: onDraggableBuild,
      canDrop: canDrop,
      onBeforeDropAccept: onBeforeDropAccept,
      dragScope: dragScope,
      tabRemoveInterceptor: tabRemoveInterceptor,
      trailing: trailing,
    );
  }

  final TabbedViewDelegate delegate;
  final TabbedViewTabBarThemeData theme;
  final bool tabReorderEnabled;
  final TabRemoveInterceptor? tabRemoveInterceptor;
  final OnTabSecondaryTap? onTabSecondaryTap;
  final UnselectedTabButtonsBehavior unselectedTabButtonsBehavior;
  final String? closeButtonTooltip;
  final TabsAreaButtonsBuilder? tabsAreaButtonsBuilder;
  final OnDraggableBuild? onDraggableBuild;
  final CanDrop? canDrop;
  final OnBeforeDropAccept? onBeforeDropAccept;
  final String? dragScope;
  final Widget? trailing;

  @override
  State<TabbedViewTabBar> createState() => _TabbedViewTabBarState();
}

class _TabbedViewTabBarState extends State<TabbedViewTabBar> {
  final TabbedViewSource _source = TabbedViewSource();
  int? _draggingTabIndex;

  @override
  void initState() {
    super.initState();
    _controllerOf(widget.delegate)?.addListener(_rebuildByTabOrSelection);
  }

  @override
  void didUpdateWidget(covariant TabbedViewTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldController = _controllerOf(oldWidget.delegate);
    final newController = _controllerOf(widget.delegate);
    if (newController != oldController) {
      oldController?.removeListener(_rebuildByTabOrSelection);
      newController?.addListener(_rebuildByTabOrSelection);
    }
  }

  TabbedViewController? _controllerOf(TabbedViewDelegate delegate) {
    if (delegate is ImperativeTabbedViewDelegate) {
      return delegate.controller;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.theme.tabsArea.visible) {
      return const SizedBox.shrink();
    }

    final provider = TabbedViewProvider(
      delegate: widget.delegate,
      source: _source,
      viewBuilder: null,
      tabReorderEnabled: widget.tabReorderEnabled,
      tabRemoveInterceptor: widget.tabRemoveInterceptor,
      contentClip: true,
      onTabSecondaryTap: widget.onTabSecondaryTap,
      unselectedTabButtonsBehavior: widget.unselectedTabButtonsBehavior,
      closeButtonTooltip: widget.closeButtonTooltip,
      tabsAreaButtonsBuilder: widget.tabsAreaButtonsBuilder,
      onDraggableBuild: widget.onDraggableBuild,
      onTabDrag: _onTabDrag,
      draggingTabIndex: _draggingTabIndex,
      canDrop: widget.canDrop,
      onBeforeDropAccept: widget.onBeforeDropAccept,
      dragScope: widget.dragScope,
      trailing: widget.trailing,
    );

    final theme = TabbedViewThemeData(
      tabsArea: widget.theme.tabsArea,
      tab: widget.theme.tab,
      menu: widget.theme.menu,
    )
      ..divider = widget.theme.divider
      ..alwaysShowDivider = widget.theme.alwaysShowDivider
      ..isDividerWithinTabArea = widget.theme.isDividerWithinTabArea;

    return TabbedViewTheme(
      data: theme,
      child: TabsArea(provider: provider),
    );
  }

  void _onTabDrag(int? tabIndex) {
    if (mounted) {
      setState(() => _draggingTabIndex = tabIndex);
    }
  }

  void _rebuildByTabOrSelection() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controllerOf(widget.delegate)?.removeListener(_rebuildByTabOrSelection);
    super.dispose();
  }
}
