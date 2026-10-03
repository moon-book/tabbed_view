import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabbed_view/tabbed_view.dart';

void main() {
  test('creates an independent default tab bar theme', () {
    final theme = TabbedViewTabBarThemeData();

    expect(theme.tabsArea, isA<TabsAreaThemeData>());
    expect(theme.tab, isA<TabThemeData>());
    expect(theme.menu, isA<TabbedViewMenuThemeData>());
    expect(theme.divider, isNull);
    expect(theme.alwaysShowDivider, isTrue);
    expect(theme.isDividerWithinTabArea, isFalse);
  });

  test('keeps custom tab bar theme values', () {
    final tabsArea = TabsAreaThemeData(color: Colors.red);
    final tab = TabThemeData(
      selectedStatus: TabStatusThemeData(),
      hoveredStatus: TabStatusThemeData(),
      textStyle: const TextStyle(color: Colors.green),
    );
    final menu = TabbedViewMenuThemeData(maxWidth: 240);
    const divider = BorderSide(color: Colors.blue, width: 2);

    final theme = TabbedViewTabBarThemeData(
      tabsArea: tabsArea,
      tab: tab,
      menu: menu,
      divider: divider,
      alwaysShowDivider: false,
      isDividerWithinTabArea: true,
    );

    expect(theme.tabsArea, same(tabsArea));
    expect(theme.tab, same(tab));
    expect(theme.menu, same(menu));
    expect(theme.divider, divider);
    expect(theme.alwaysShowDivider, isFalse);
    expect(theme.isDividerWithinTabArea, isTrue);
  });

  test('provides all predefined tab bar themes', () {
    final themes = <TabbedViewTabBarThemeData>[
      TabbedViewTabBarThemeData.classic(),
      TabbedViewTabBarThemeData.underline(),
      TabbedViewTabBarThemeData.minimalist(),
      TabbedViewTabBarThemeData.folder(),
    ];

    expect(themes, hasLength(4));
    for (final theme in themes) {
      expect(theme.tabsArea, isA<TabsAreaThemeData>());
      expect(theme.tab, isA<TabThemeData>());
      expect(theme.menu, isA<TabbedViewMenuThemeData>());
    }
  });
}
