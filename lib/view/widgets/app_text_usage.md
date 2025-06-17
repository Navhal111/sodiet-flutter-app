# AppText Widget Documentation

This document provides examples and guidelines for using the custom AppText widget to maintain consistent text styling throughout the SoDiet application.

## Basic Usage

The `AppText` widget is the base widget that can be used for all text in the application. It has several convenience subclasses to make usage simpler:

- `RegularText` - Uses Poppins Regular (weight 400)
- `MediumText` - Uses Poppins Medium (weight 500)
- `SemiBoldText` - Uses Poppins SemiBold (weight 600)
- `BoldText` - Uses Poppins Bold (weight 700)

## Examples

### Basic Text

```dart
RegularText('This is regular text')
MediumText('This is medium text')
SemiBoldText('This is semi-bold text')
BoldText('This is bold text')
```

### Customizing Text Size

```dart
RegularText('Small text', fontSize: 12)
MediumText('Standard text', fontSize: 14)
BoldText('Large text', fontSize: 18)
SemiBoldText('Extra large text', fontSize: 24)
```

### Customizing Text Color

```dart
RegularText('Default black text')
RegularText('Custom color text', textColor: Colors.blue)
RegularText('Primary color text', textColor: Theme.of(context).primaryColor)
RegularText('Secondary text', textColor: Colors.black54)
```

### Text Alignment

```dart
RegularText(
  'This text is centered',
  textAlign: TextAlign.center
)

RegularText(
  'This text is right-aligned',
  textAlign: TextAlign.right
)
```

### Multi-line Text with Overflow

```dart
RegularText(
  'This is a very long text that will be truncated with an ellipsis if it exceeds 2 lines',
  maxLines: 2,
  overflow: TextOverflow.ellipsis
)
```

### Line Height and Letter Spacing

```dart
RegularText(
  'Text with adjusted line height',
  height: 1.5
)

RegularText(
  'Text with adjusted letter spacing',
  letterSpacing: 0.5
)
```

### Text with Decoration

```dart
RegularText(
  'Underlined text',
  decoration: TextDecoration.underline
)
```

## Best Practices

1. Use the appropriate font weight based on the UI hierarchy:

   - `BoldText` for main headings
   - `SemiBoldText` for subheadings
   - `MediumText` for emphasized text or buttons
   - `RegularText` for body text

2. Use consistent font sizes throughout the app:

   - 24-28px for main headings
   - 18-20px for subheadings
   - 16px for emphasized text
   - 14px for body text
   - 12px for captions or helper text

3. Limit color variations to those defined in the app theme to maintain consistency.

4. Use `maxLines` and `overflow` properties to handle variable text content gracefully.
