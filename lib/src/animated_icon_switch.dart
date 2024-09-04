import 'package:flutter/material.dart';

class AnimatedIconSwitch extends StatefulWidget {
  const AnimatedIconSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.borderRadius = 360,
    this.inactiveColor = const Color.fromARGB(255, 207, 207, 207),
    this.activeColor = const Color.fromARGB(255, 67, 175, 71),
    this.shadowColor,
    this.height = 36,
    this.width = 69,
    this.elevation = 0,
    this.inactiveThumbColor = Colors.white,
    this.activeThumbColor = Colors.white,
    this.withIcons = false,
    this.iconOnThumb = false,
    this.inactiveIcon = Icons.sunny,
    this.activeIcon = Icons.brightness_2,
    this.inactiveIconSize = 24,
    this.activeIconSize = 24,
    this.inactiveIconColor = Colors.white,
    this.activeIconColor = Colors.white,
    this.withIconAnimation = false,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  /*-----------------
    R E Q U I R E D
  ------------------*/

  /// Whether this switch is on or off.
  final bool value;

  /// Called when the user toggles with switch on or off.
  ///
  /// The switch passes the new value to the callback but does not actually change state until the parent widget rebuilds the switch with the new value.
  ///
  /// If null, the switch will be displayed as disabled.
  final void Function(bool value) onChanged;

  /*-------
    A L L
  --------*/

  /// The borderRadius of the thumb and the switch.
  final double borderRadius;

  /*---------------------
    M A I N   W I D G E T
  ---------------------*/

  /// The color of the switch when the switch is disabled.
  ///
  /// Note: changing the inactiveColor requires a cold reload (restart).
  final Color inactiveColor;

  /// The color of the switch when the switch is enabled.
  ///
  /// Note: changing the activeColor requires a cold reload (restart).
  final Color activeColor;

  /// The color of the elevation shadow.
  final Color? shadowColor;

  /// The height of the widget.
  ///
  /// Note: changing the height requires a cold reload (restart).
  final double height;

  /// The width of the widget.
  ///
  /// Note: changing the width requires a cold reload (restart).
  final double width;

  /// The elevation of the widget.
  final double elevation;

  /*------------------------
    T H U M B    W I D G E T
  ------------------------*/

  /// The color of the thumb when the switch is enabled.
  ///
  /// Note: changing the activeThumbColor requires a cold reload (restart).
  final Color? activeThumbColor;

  /// The color of the thumb when the switch is disabled.
  ///
  /// Note: changing the inactiveThumbColor requires a cold reload (restart).
  final Color? inactiveThumbColor;

  /// Wether the widget will have icons inside the switch or not.
  final bool withIcons;

  /// Whether the icons will be behind the thumb or on the thumb.
  final bool iconOnThumb;

  /// The icon when the switch is disabled.
  final IconData? inactiveIcon;

  /// The size of the icon when the switch is disabled.
  final double? inactiveIconSize;

  /// The color of the icon when the switch is disabled.
  final Color? inactiveIconColor;

  /// The icon when the switch is enabled.
  final IconData? activeIcon;

  /// The size of the icon when the switch is enabled.
  final double? activeIconSize;

  /// The color of the icon when the switch is enabled.
  final Color? activeIconColor;

  /*------------------
    A N I M A T I O N
  ------------------*/

  /// Wether the icons will have a pop up animation or not.
  ///
  /// Under maintenance:
  ///
  /// - Animation when value changes from another function.
  final bool withIconAnimation;

  /// The animation duration of the icon pop up animation.
  ///
  /// Note: changing the animationDuration requires a cold reload (restart).
  final Duration animationDuration;

  @override
  State<AnimatedIconSwitch> createState() => _AnimatedIconSwitchState();
}

class _AnimatedIconSwitchState extends State<AnimatedIconSwitch>
    with TickerProviderStateMixin {
  double widgetWidth = 36;
  double widgetHeight = 69;

  bool isDragging = false;
  bool isActiveByDragging = false;

  late AnimationController popUpAnimationController;
  late Animation<double> popUpAnimation;
  late Tween<double> popUpTween;
  bool isPlayingAnimation = false;

  late AnimationController translateAnimationController;
  late Animation<double> translateAnimation;
  late Tween<double> translateTween;

  late AnimationController backgroundColorAnimationController;
  late Animation<Color?> backgroundColorAnimation;

  double? startHorizontal;

  @override
  void initState() {
    super.initState();

    // Color tween
    backgroundColorAnimationController = AnimationController(
      vsync: this,
    );
    backgroundColorAnimation = ColorTween(
      begin: widget.inactiveColor,
      end: widget.activeColor,
    ).animate(
      backgroundColorAnimationController,
    );

    // Pop up animation
    popUpAnimationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    popUpTween = Tween<double>(begin: 1, end: 0);
    popUpAnimation = popUpTween.animate(
      CurvedAnimation(
        parent: popUpAnimationController,
        curve: Curves.easeInBack,
      ),
    );
    popUpAnimation.addListener(() {
      setState(() {});
    });

    // Translate animation
    translateAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    translateTween = Tween<double>(begin: 3, end: 3);
    translateAnimation = translateTween.animate(
      CurvedAnimation(
        parent: translateAnimationController,
        curve: Curves.fastOutSlowIn,
      ),
    );
    translateAnimation.addListener(
      () {
        backgroundColorAnimationController.value =
            (translateAnimation.value - 3) / (widgetWidth - widgetHeight + 3);
        if (isDragging) {
          double leftBounds = widgetWidth - widgetHeight;
          popUpTween.begin =
              (1 - ((translateAnimation.value - 3) / leftBounds * 2))
                  .abs()
                  .clamp(0, 1);
        }
        if (translateAnimation.isCompleted) {
          isDragging = false;
          isActiveByDragging = false;
          popUpTween.begin = 1;
          translateTween.begin = translateTween.end;
          translateAnimationController.reset();
        }
        setState(() {});
      },
    );

    widgetHeight = widget.height;
    widgetWidth = widget.width;
  }

  @override
  Widget build(BuildContext context) {
    // Fix: switch not changing when value is changed from another function.
    if (widget.value && translateTween.begin == 3 && !isDragging) {
      translateTween.end = widgetWidth - widgetHeight + 3;
      translateAnimationController.forward();
    } else if (!widget.value &&
        translateTween.begin == widgetWidth - widgetHeight + 3 &&
        !isDragging) {
      translateTween.end = 3;
      translateAnimationController.forward();
    }
    // Add elevetion property
    return Material(
      elevation: widget.elevation,
      shadowColor: widget.shadowColor,
      borderRadius: BorderRadius.circular(widget.borderRadius),
      // color: widget.inactiveColor,
      color: Colors.transparent,
      surfaceTintColor: Colors.transparent,

      // Main widget
      child: GestureDetector(
        onTap: () {
          if (isPlayingAnimation) return;

          if (widget.withIconAnimation) {
            isPlayingAnimation = true;
            popUpAnimationController.forward().then(
              (value) {
                if (widget.value) {
                  translateTween.end = 3;
                } else {
                  translateTween.end = widgetWidth - widgetHeight + 3;
                }
                widget.onChanged(!widget.value);
                translateAnimationController.forward();
                popUpAnimationController.reverse().then(
                      (value) => isPlayingAnimation = false,
                    );
              },
            );
          } else {
            translateTween.begin = translateTween.end;
            translateAnimationController.reset();
            if (widget.value) {
              translateTween.end = 3;
            } else {
              translateTween.end = widgetWidth - widgetHeight + 3;
            }
            widget.onChanged(!widget.value);
            translateAnimationController.forward();
          }
        },
        onPanStart: (DragStartDetails details) {
          if (isPlayingAnimation) return;
          isDragging = true;
          startHorizontal = details.localPosition.dx - translateAnimation.value;
        },
        onPanUpdate: (details) {
          if (isPlayingAnimation || startHorizontal == null) return;
          double leftVal = details.localPosition.dx - startHorizontal!;
          double leftBounds = widgetWidth - widgetHeight + 3;
          translateTween.begin = leftVal.clamp(3, leftBounds);

          // Animation while dragging
          popUpTween.begin = (1 - (leftVal / leftBounds * 2)).abs().clamp(0, 1);
          isActiveByDragging =
              (1 - (leftVal / leftBounds * 2)).clamp(-1, 1) < 0;
          backgroundColorAnimationController.value =
              (translateAnimation.value - 3) / (widgetWidth - widgetHeight + 3);

          setState(() {});
        },
        onPanEnd: (details) {
          if (isPlayingAnimation) return;
          startHorizontal = null;
          double center = (widgetWidth - widgetHeight + 3) / 2;
          if (center <= translateTween.begin!) {
            translateTween.end = widgetWidth - widgetHeight + 3;

            widget.onChanged(true);
          } else {
            translateTween.end = 3;

            widget.onChanged(false);
          }
          translateAnimationController.forward();

          setState(() {});
        },
        child: Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            color: backgroundColorAnimation.value,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Active Icon - if icons are enabled and icon is not on thumb
              if (widget.withIcons && !widget.iconOnThumb)
                Positioned(
                  left: 7,
                  child: Transform.scale(
                    scale: popUpAnimation.value,
                    child: Icon(
                      widget.activeIcon,
                      size: widget.activeIconSize,
                      color: widget.activeIconColor,
                    ),
                  ),
                ),
              // Inactive icon - if icons are enabled and icon is not on thumb
              if (widget.withIcons && !widget.iconOnThumb)
                Positioned(
                  right: 7,
                  child: Transform.scale(
                    scale: popUpAnimation.value,
                    child: Icon(
                      widget.inactiveIcon,
                      size: widget.inactiveIconSize,
                      color: widget.inactiveIconColor,
                    ),
                  ),
                ),
              // Thumb widget
              Positioned(
                left: translateAnimation.value,
                child: Material(
                  // To avoid weird shadow
                  elevation: widget.value
                      ? widget.activeThumbColor == Colors.transparent
                          ? 0
                          : 2
                      : widget.inactiveThumbColor == Colors.transparent
                          ? 0
                          : 2,
                  // ###----------------###

                  // border radius
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  // color
                  color: widget.value
                      ? widget.activeThumbColor
                      : widget.inactiveThumbColor,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: widgetHeight - 5,
                    height: widgetHeight - 5,
                    decoration: BoxDecoration(
                      // color
                      color: widget.value
                          ? widget.activeThumbColor
                          : widget.inactiveThumbColor,
                      // border radius
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                    ),
                    // Icon widget
                    child: widget.withIcons && widget.iconOnThumb
                        ? Transform.scale(
                            scale: popUpAnimation.value,
                            child: Icon(
                              // icon
                              (!isDragging ? widget.value : isActiveByDragging)
                                  ? widget.activeIcon
                                  : widget.inactiveIcon,
                              // color
                              color: (!isDragging
                                      ? widget.value
                                      : isActiveByDragging)
                                  ? widget.activeIconColor
                                  : widget.inactiveIconColor,
                              // size
                              size: (!isDragging
                                      ? widget.value
                                      : isActiveByDragging)
                                  ? widget.activeIconSize
                                  : widget.inactiveIconSize,
                            ),
                          )
                        : const SizedBox(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
