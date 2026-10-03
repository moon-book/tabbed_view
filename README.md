[![](https://img.shields.io/pub/v/tabbed_view.svg)](https://pub.dev/packages/tabbed_view)
[![](https://img.shields.io/badge/demo-try%20it%20out-blue)](https://caduandrade.github.io/tabbed_view_demo/)
[![](https://img.shields.io/badge/Flutter-%E2%9D%A4-red)](https://flutter.dev/)
![](https://img.shields.io/badge/%F0%9F%91%8D%20and%20%E2%AD%90-are%20free%20and%20motivate%20me-yellow)

# Tabbed view

Flutter widget inspired by the classic Desktop-style tab component. Supports customizable themes.

## Standalone tab bar

`TabbedViewTabBar` lets the tabs and content participate in different parts of
your layout while sharing the same controller:

```dart
Column(
  children: [
    TabbedViewTabBar(
      controller: controller,
      theme: TabbedViewTabBarThemeData.classic(
        colorSet: Colors.teal,
      ),
    ),
    Expanded(
      child: TabbedView(
        controller: controller,
        tabsAreaVisible: false,
      ),
    ),
  ],
)
```

The standalone bar also provides `TabbedViewTabBar.declarative` for externally
managed tab lists and selections. Its theme is independent from
`TabbedViewTheme`; use `TabbedViewTabBarThemeData` to customize the tabs area,
individual tabs, overflow menu, and divider.

![](https://caduandrade.github.io/tabbed_view/classic_top_light.png)

![](https://caduandrade.github.io/tabbed_view/classic_bottom_dark.png)

![](https://caduandrade.github.io/tabbed_view/classic_left_light.png)

![](https://caduandrade.github.io/tabbed_view/classic_left_stacked_light.png)

![](https://caduandrade.github.io/tabbed_view/underline_top_light.png)

![](https://caduandrade.github.io/tabbed_view/underline_bottom_dark.png)

![](https://caduandrade.github.io/tabbed_view/minimalist_top_light.png)

![](https://caduandrade.github.io/tabbed_view/minimalist_bottom_dark.png)

---

Get started quickly with the interactive demo and documentation [here](https://caduandrade.github.io/tabbed_view_demo/).
