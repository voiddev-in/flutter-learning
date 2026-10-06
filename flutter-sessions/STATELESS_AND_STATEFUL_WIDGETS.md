# Stateless vs Stateful Widgets

Since widgets are blueprints, how do we handle things that change over time (like user input or animations)? 

Flutter handles this by dividing widgets into two main categories:

## 1. StatelessWidget
A widget that **does not change** its internal state after it's built.
- **When to use:** For static content like labels, icons, or a simple layout.
- **Analogy:** A printed poster. Once it's printed, it doesn't change.

```dart
class MyStaticLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("I am static and will not change.");
  }
}
```

## 2. StatefulWidget
A widget that **can change** its internal state over time (e.g., when a user clicks it or data arrives).
- **When to use:** For dynamic content like forms, animations, or interactive counters.
- **Analogy:** A digital scoreboard. It updates its numbers based on events.

```dart
// The widget itself is immutable...
class MyCounter extends StatefulWidget {
  @override
  State<MyCounter> createState() => _MyCounterState();
}

// ...but it creates a mutable State object!
class _MyCounterState extends State<MyCounter> {
  int count = 0; // State can change!

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          count++; // Calling setState triggers a rebuild!
        });
      },
      child: Text("Count: $count"),
    );
  }
}
```
