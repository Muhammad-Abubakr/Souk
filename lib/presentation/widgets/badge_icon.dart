import 'package:flutter/material.dart';

/// [BadgeIconButton] is a widget that creates a badge on the
/// provided `badgeAlignment` of the provided `icon`. It
/// also asks about an `onPressed` function that executes
/// when the button is pressed. `badgeAlignment` sets the
/// alignment of the badge around the icon. `splashRadius`
/// sets the splash radius when the button is pressed.
/// [Padding] sets the padding around the BadgeIconButton.
class BadgeIconButton extends StatelessWidget {
  int value;
  final EdgeInsetsGeometry? padding;
  final Icon icon;
  final Alignment? badgeAlignment;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? splashRadius;
  final void Function() onPressed;
  final Color? splashColor;
  final Color? focusColor;
  final double? backgroundRadius;
  final Color? badgeBackground;
  final Color? badgeForeground;

  BadgeIconButton({
    Key? key,
    this.padding,
    required this.value,
    required this.icon,
    required this.onPressed,
    this.splashRadius,
    this.badgeAlignment,
    this.backgroundColor,
    this.foregroundColor,
    this.splashColor,
    this.focusColor,
    this.backgroundRadius,
    this.badgeBackground,
    this.badgeForeground,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// [Padding] sets the padding around the BadgeIconButton.
    return Padding(
      padding: padding ?? const EdgeInsets.all(0),

      /// [CircleAvatar] is wrapped around the [Stack] in order to prevent
      /// any extra spacing between the badge and the Icon.
      child: CircleAvatar(
        radius: backgroundRadius ?? 24,
        backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
        foregroundColor:
            foregroundColor ?? Theme.of(context).colorScheme.secondary,

        /// [Stack] is used to place the Icon Badge at just the right place
        /// with the icon. It's children are an [IconButton] that gets the
        /// [Icon] argument which [BadgeIconButton] gets, and
        child: Stack(
          fit: StackFit.loose,
          alignment: badgeAlignment ?? Alignment.topLeft,
          children: [
            IconButton(
              onPressed: onPressed,
              icon: icon,
              splashColor: splashColor,
              splashRadius: splashRadius ?? 24,
              focusColor: focusColor,
              color: foregroundColor,
            ),

            /// it has a [CircleAvatar] in which it contains a [Text] with
            /// [FittedBox] wrapped around in order to prevent the text from
            /// spilling. It is the Badge of the [Icon] which displays the
            /// item count.
            if (value > 0)
              CircleAvatar(
                backgroundColor: badgeBackground,
                radius:
                    Theme.of(context).textTheme.labelSmall!.fontSize!.abs() *
                        0.8,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    "$value",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: badgeForeground,
                          fontFamily: 'sf-pro-text',
                          fontWeight: FontWeight.w300,
                        ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
