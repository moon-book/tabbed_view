import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabbed_view/src/internal/tab/tab_button_widget.dart';
import 'package:tabbed_view/src/internal/tab/tab_widget.dart';
import 'package:tabbed_view/src/internal/menu_widget.dart';
import 'package:tabbed_view/tabbed_view.dart';

void main() {
  Widget buildApp(Widget child, {double width = 800, double height = 300}) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(width: width, height: height, child: child),
        ),
      ),
    );
  }

  group('TabbedViewTabBar imperative', () {
    late TabbedViewController controller;

    setUp(() {
      controller = TabbedViewController([
        TabData(id: 1, text: 'One', view: const Text('Content one')),
        TabData(id: 2, text: 'Two', view: const Text('Content two')),
      ]);
    });

    tearDown(() => controller.dispose());

    testWidgets('shares selection and tab changes with TabbedView',
        (tester) async {
      await tester.pumpWidget(buildApp(Column(children: [
        TabbedViewTabBar(controller: controller),
        Expanded(
          child: TabbedView(
            controller: controller,
            tabsAreaVisible: false,
          ),
        ),
      ])));

      await tester.tap(find.text('Two'));
      await tester.pump();

      expect(controller.selectedIndex, 1);
      expect(find.text('Content two'), findsOneWidget);

      controller.addTab(TabData(id: 3, text: 'Three'));
      await tester.pump();
      expect(find.text('Three'), findsOneWidget);

      controller.selectedIndex = 2;
      await tester.pump();
      final selectedTab = tester.widget<TabWidget>(
        find.byWidgetPredicate(
          (widget) => widget is TabWidget && widget.index == 2,
        ),
      );
      expect(selectedTab.status, TabStatus.selected);
    });

    testWidgets('uses its own theme instead of the content theme',
        (tester) async {
      final barTheme = TabbedViewTabBarThemeData(
        tab: TabThemeData(
          selectedStatus: TabStatusThemeData(),
          hoveredStatus: TabStatusThemeData(),
          textStyle: const TextStyle(color: Colors.green),
        ),
      );

      await tester.pumpWidget(MaterialApp(
        home: TabbedViewTheme(
          data: TabbedViewThemeData(
            tab: TabThemeData(
              selectedStatus: TabStatusThemeData(),
              hoveredStatus: TabStatusThemeData(),
              textStyle: const TextStyle(color: Colors.red),
            ),
          ),
          child: Scaffold(
            body: TabbedViewTabBar(controller: controller, theme: barTheme),
          ),
        ),
      ));

      final label = tester.widget<Text>(find.text('One'));
      expect(label.style?.color, Colors.green);
    });

    testWidgets('supports trailing widgets, overflow, and vertical layout',
        (tester) async {
      controller.addTab(TabData(id: 3, text: 'Three'));
      final theme = TabbedViewTabBarThemeData.classic();
      theme.tabsArea.position = TabBarPosition.left;

      await tester.pumpWidget(buildApp(
        TabbedViewTabBar(
          controller: controller,
          theme: theme,
          trailing: const Text('Trailing'),
        ),
        width: 180,
        height: 100,
      ));
      await tester.pumpAndSettle();

      expect(find.text('Trailing'), findsOneWidget);
      expect(find.byType(MenuWidget), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('reorders tabs by dragging', (tester) async {
      await tester.pumpWidget(buildApp(
        TabbedViewTabBar(controller: controller),
      ));

      final start = tester.getCenter(find.text('One'));
      final secondTab = find.byWidgetPredicate(
        (widget) => widget is TabWidget && widget.index == 1,
      );
      final end = tester.getRect(secondTab).centerRight - const Offset(2, 0);
      await tester.timedDragFrom(
        start,
        end - start,
        const Duration(seconds: 1),
      );
      await tester.pumpAndSettle();

      expect(controller.tabs.map((tab) => tab.id), orderedEquals([2, 1]));
    });
  });

  group('TabbedViewTabBar declarative', () {
    testWidgets('emits select and close intents without mutating tabs',
        (tester) async {
      final tabs = [
        TabData(id: 'one', text: 'One'),
        TabData(id: 'two', text: 'Two'),
      ];
      TabData? selected;
      TabData? closed;

      await tester.pumpWidget(buildApp(TabbedViewTabBar.declarative(
        tabs: tabs,
        selectedTabId: 'one',
        onTabSelect: (tab) => selected = tab,
        onTabClose: (tab) => closed = tab,
      )));

      await tester.tap(find.text('Two'));
      await tester.pump();
      expect(selected, same(tabs[1]));

      final firstCloseButton = find.descendant(
        of: find.byWidgetPredicate(
          (widget) => widget is TabWidget && widget.index == 0,
        ),
        matching: find.byType(TabButtonWidget),
      );
      await tester.tap(firstCloseButton);
      await tester.pump();

      expect(closed, same(tabs[0]));
      expect(tabs.map((tab) => tab.id), orderedEquals(['one', 'two']));
    });

    testWidgets('emits detach and attach intents between tab bars',
        (tester) async {
      final sourceTab = TabData(id: 'source', text: 'Source');
      final targetTab = TabData(id: 'target', text: 'Target');
      TabData? detached;
      TabData? attached;

      await tester.pumpWidget(buildApp(Column(children: [
        TabbedViewTabBar.declarative(
          tabs: [sourceTab],
          selectedTabId: sourceTab.id,
          onTabDetach: (tab) => detached = tab,
        ),
        TabbedViewTabBar.declarative(
          tabs: [targetTab],
          selectedTabId: targetTab.id,
          onTabAttach: (tab, target) => attached = tab,
        ),
      ])));

      final start = tester.getCenter(find.text('Source'));
      final end = tester.getCenter(find.text('Target'));
      await tester.dragFrom(start, end - start);
      await tester.pumpAndSettle();

      expect(detached, same(sourceTab));
      expect(attached, same(sourceTab));
    });
  });
}
