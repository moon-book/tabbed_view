import 'package:flutter/material.dart';

import 'tab_style_resolver.dart';
import 'tab_status_theme_data.dart';
import 'tab_theme_data.dart';
import 'tabbed_view_menu_theme_data.dart';
import 'tabbed_view_theme_data.dart';
import 'tabs_area_theme_data.dart';

/// Defines the appearance of a standalone tab bar.
///
/// This theme intentionally contains only values used by the tab bar. It does
/// not inherit from [TabbedViewThemeData], so a standalone tab bar can be
/// styled independently from its associated content view.
class TabbedViewTabBarThemeData {
  TabbedViewTabBarThemeData({
    TabsAreaThemeData? tabsArea,
    TabThemeData? tab,
    TabbedViewMenuThemeData? menu,
    this.divider,
    this.alwaysShowDivider = true,
    this.isDividerWithinTabArea = false,
  })  : tabsArea = tabsArea ?? TabsAreaThemeData(),
        tab = tab ??
            TabThemeData(
              selectedStatus: TabStatusThemeData(),
              hoveredStatus: TabStatusThemeData(),
            ),
        menu = menu ?? TabbedViewMenuThemeData();

  TabbedViewTabBarThemeData._fromTabbedViewThemeData(
    TabbedViewThemeData theme,
  )   : tabsArea = theme.tabsArea,
        tab = theme.tab,
        menu = theme.menu,
        divider = theme.divider,
        alwaysShowDivider = theme.alwaysShowDivider,
        isDividerWithinTabArea = theme.isDividerWithinTabArea;

  /// Builds the predefined classic tab bar theme.
  factory TabbedViewTabBarThemeData.classic({
    Brightness? brightness,
    MaterialColor? colorSet,
    double? fontSize,
    Color? borderColor,
    double? tabRadius,
    TabStyleResolver? tabStyleResolver,
  }) {
    return TabbedViewTabBarThemeData._fromTabbedViewThemeData(
      TabbedViewThemeData.classic(
        brightness: brightness,
        colorSet: colorSet,
        fontSize: fontSize,
        borderColor: borderColor,
        tabRadius: tabRadius,
        tabStyleResolver: tabStyleResolver,
      ),
    );
  }

  /// Builds the predefined underline tab bar theme.
  factory TabbedViewTabBarThemeData.underline({
    Brightness? brightness,
    MaterialColor? colorSet,
    MaterialColor? underlineColorSet,
    double? fontSize,
    UnderlineTabStyleResolver? tabStyleResolver,
  }) {
    return TabbedViewTabBarThemeData._fromTabbedViewThemeData(
      TabbedViewThemeData.underline(
        brightness: brightness,
        colorSet: colorSet,
        underlineColorSet: underlineColorSet,
        fontSize: fontSize,
        tabStyleResolver: tabStyleResolver,
      ),
    );
  }

  /// Builds the predefined minimalist tab bar theme.
  factory TabbedViewTabBarThemeData.minimalist({
    Brightness? brightness,
    MaterialColor? colorSet,
    double? fontSize,
    double? initialGap,
    double? gap,
    double? tabRadius,
    MinimalistTabStyleResolver? tabStyleResolver,
  }) {
    return TabbedViewTabBarThemeData._fromTabbedViewThemeData(
      TabbedViewThemeData.minimalist(
        brightness: brightness,
        colorSet: colorSet,
        fontSize: fontSize,
        initialGap: initialGap,
        gap: gap,
        tabRadius: tabRadius,
        tabStyleResolver: tabStyleResolver,
      ),
    );
  }

  /// Builds the predefined folder tab bar theme.
  factory TabbedViewTabBarThemeData.folder({
    Brightness? brightness,
    MaterialColor? colorSet,
    double? fontSize,
    double? initialGap,
    FolderTabStyleResolver? tabStyleResolver,
  }) {
    return TabbedViewTabBarThemeData._fromTabbedViewThemeData(
      TabbedViewThemeData.folder(
        brightness: brightness,
        colorSet: colorSet,
        fontSize: fontSize,
        initialGap: initialGap,
        tabStyleResolver: tabStyleResolver,
      ),
    );
  }

  final TabsAreaThemeData tabsArea;
  final TabThemeData tab;
  final TabbedViewMenuThemeData menu;
  final BorderSide? divider;
  final bool alwaysShowDivider;
  final bool isDividerWithinTabArea;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TabbedViewTabBarThemeData &&
          runtimeType == other.runtimeType &&
          tabsArea == other.tabsArea &&
          tab == other.tab &&
          menu == other.menu &&
          divider == other.divider &&
          alwaysShowDivider == other.alwaysShowDivider &&
          isDividerWithinTabArea == other.isDividerWithinTabArea;

  @override
  int get hashCode => Object.hash(
        tabsArea,
        tab,
        menu,
        divider,
        alwaysShowDivider,
        isDividerWithinTabArea,
      );
}
