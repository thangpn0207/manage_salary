import 'package:flutter/material.dart';

/// Defines the standard size variants for the button height.
enum ButtonSize {
  small,
  medium, // Default
  large,
}

/// A customizable button that uses the application's theme and supports size variations.
///
/// If a [width] is provided, the button will have that exact width.
/// If [width] is null, the button will expand horizontally to fill
/// the available space within its parent constraints.
///
/// The [size] parameter controls the button's height and internal padding/text style
/// if not overridden by a custom [style].
class BaseButton extends StatelessWidget {
  /// The text displayed on the button.
  final String text;

  /// The callback function that is called when the button is tapped.
  /// If null, the button will be disabled.
  final VoidCallback? onPressed;

  /// An optional icon to display before the text.
  final Widget? icon;

  /// The fixed width of the button. If null, the button scales horizontally.
  final double? width;

  /// The size variant of the button (small, medium, large), affecting its height.
  /// Defaults to [ButtonSize.medium].
  final ButtonSize size;

  /// Optional custom styling for the button, which overrides the theme and size defaults.
  final ButtonStyle? style;

  /// Creates a ScalableButton.
  ///
  /// The [text] and [onPressed] arguments are required (though [onPressed] can be null
  /// to disable the button).
  const BaseButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.width,
    this.size = ButtonSize.medium, // Default size is medium
    this.style,
  });

  // Helper to get the height based on the size enum
  double _getButtonHeight() {
    switch (size) {
      case ButtonSize.small:
        return 36.0; // Example height for small
      case ButtonSize.large:
        return 60.0; // Example height for large
      case ButtonSize.medium:
        return 48.0; // Example height for medium (often Material default)
    }
  }

  // Helper to potentially get size-specific style adjustments
  // This could adjust padding, text size etc. based on ButtonSize
  // It merges with the theme and the custom style passed in.
  ButtonStyle _getEffectiveButtonStyle(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ButtonStyle? themeStyle = theme.elevatedButtonTheme.style;
    // Define a standard border radius
    const double borderRadiusValue = 12.0; // You can adjust this value
    final RoundedRectangleBorder shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadiusValue),
    );

    // Define base styles per size (can be adjusted)
    ButtonStyle sizeStyle;
    switch (size) {
      case ButtonSize.small:
        sizeStyle = ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle:
              theme.textTheme.labelMedium, // Smaller text for small buttons
          shape: shape, // Apply the shape
        );
        break;
      case ButtonSize.large:
        sizeStyle = ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle:
              theme.textTheme.labelLarge?.copyWith(fontSize: 18), // Larger text
          shape: shape, // Apply the shape
        );
        break;
      case ButtonSize.medium:
        // Added default here for clarity
        sizeStyle = ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: theme.textTheme.labelLarge, // Default button text style
          shape: shape, // Apply the shape
        );
        break;
    }

    // Merge styles: Custom style > Size style > Theme style
    // The 'style' passed to the constructor takes highest priority.
    // Then the size-specific style.
    // Finally, the theme's button style.

    // If themeStyle already has a shape, sizeStyle's shape will override it.
    // If the custom 'style' has a shape, it will override sizeStyle's shape.
    final ButtonStyle mergedWithSize = sizeStyle.merge(themeStyle);
    return style?.merge(mergedWithSize) ?? mergedWithSize;
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle effectiveStyle = _getEffectiveButtonStyle(context);
    final double buttonHeight = _getButtonHeight();

    // Create the core button widget with the effective style
    final Widget buttonContent = icon != null
        ? ElevatedButton.icon(
            onPressed: onPressed,
            icon: icon!,
            label: Text(text),
            style: effectiveStyle, // Apply merged style
          )
        : ElevatedButton(
            onPressed: onPressed,
            style: effectiveStyle, // Apply merged style
            child: Text(text),
          );

    // Apply width AND height constraint logic using SizedBox
    if (width != null) {
      // --- Fixed Width ---
      return SizedBox(
        width: width,
        height: buttonHeight, // Enforce height
        child: buttonContent,
      );
    } else {
      // --- Scalable Width (Fill Horizontal) ---
      return SizedBox(
        width: double.infinity,
        height: buttonHeight, // Enforce height
        child: buttonContent,
      );
    }
  }
}
