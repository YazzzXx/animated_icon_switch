<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

A fully customizable, draggable, and animated switch featuring multiple options and a smooth loading animation.

## Getting started

You only need to import the package:
```dart
import 'package:animated_icon_switch.dart'
```

## Usage

Here is a simple light/dark mode switch with icons.
```dart
BetterSwitch(
    withIcons: true,
    activeColor: Colors.grey.shade900,
    activeIcon: Icons.brightness_2,
    shadowColor: Colors.grey.withAlpha(150),
    inactiveIcon: Icons.sunny,
    elevation: 6,
    value: value,
    onChanged: (v) {
        value = v;
        setState(() {});
    },
),
```

## Features
Here is a list of all the options:

### Main widget options
- borderRadius: the borderRadius of the thumb and the switch.
- inactiveColor: the color of the switch when the switch is disabled.
- activeColor: the color of the switch when the switch is enabled.
- shadowColor: the color of the elevation shadow.
- height: the height of the widget.
- width: the width of the widget.
- elevation: the elevation of the widget.

### Thumb widget options
- activeThumbColor: the color of the thumb when the switch is enabled.
- inactiveThumbColor: the color of the thumb when the switch is disabled.
- withIcons: wether the widget will have icons inside the switch or not.
- iconOnThumb: whether the icons will be on the thumb or behind the thumb.
- inactiveIcon: changing icon for inactive state.
- inactiveIconSize: changing icon size for inactive state.
- inactiveIconColor: changing icon color for inactive state.
- activeIcon: changing icon for active states.
- activeIconSize: changing icon size for active state.
- activeIconColor: changing icon color for active state.

### Animations
- withIconAnimation: wether the icons will have a pop up animation or not.
- animationDuration: the animation duration of the icon pop up animation.

## Caution

Some options need a cold reload (restart), Here are the options:
- inactiveColor
- activeColor
- height
- width
- inactiveThumbColor
- activeThumbColor
- withIconAnimation
- animationDuration
