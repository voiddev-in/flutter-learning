# Row and Column in Flutter

In Flutter, `Row` and `Column` are essential layout widgets used to arrange other widgets either horizontally or vertically. Based on the code in your `flutter-learning` app, here is a clear explanation of how they work and how they are used.

## 1. Column (Vertical Layout)

A `Column` widget arranges its children in a **vertical** line, from top to bottom.

### How it's used in your app
You have several examples of `Column` in your codebase:
- In `app/lib/main.dart`, you use a `Column` to stack an `ElevatedButton` ("Increase") and a `Text` widget ("Count $count") vertically.
- In `app/lib/examples/widgets_and_tree_lesson.dart`, `Column` is used extensively to build the `ProfileScreenExample`, stacking a header, user details, skills, and a contact button.

### Key Properties Used:
- `children:` Takes a list (`[]`) of widgets that will be displayed vertically.
- `mainAxisAlignment:` Controls how the children are aligned along the **main axis** (which is vertical for a Column).
  - Example from your code: `mainAxisAlignment: MainAxisAlignment.center` vertically centers the widgets.
- `crossAxisAlignment:` Controls how the children are aligned along the **cross axis** (which is horizontal for a Column).
  - Example from your code: `crossAxisAlignment: CrossAxisAlignment.stretch` in `ProfileScreenExample` stretches the child widgets to fill the width of the screen.
  - Example from your code: `crossAxisAlignment: CrossAxisAlignment.start` in `SkillsSection` aligns the "Skills" text to the left side (start).

## 2. Row (Horizontal Layout)

A `Row` widget arranges its children in a **horizontal** line, from left to right.

### How it's used in your app
- In `app/lib/examples/widgets_and_tree_lesson.dart` inside the `SkillsSection`, you use a `Row` to display three `Chip` widgets ("Dart", "Flutter", "Firebase") side-by-side.

### Key Properties Used:
- `children:` Takes a list (`[]`) of widgets that will be displayed horizontally.
- `mainAxisAlignment:` Controls how the children are aligned along the **main axis** (which is horizontal for a Row).
  - Example from your code: `mainAxisAlignment: MainAxisAlignment.spaceAround` distributes the free horizontal space evenly between and around the children, spacing out the "Dart", "Flutter", and "Firebase" chips nicely.

## Summary

| Widget | Direction | Main Axis | Cross Axis |
| :--- | :--- | :--- | :--- |
| **Column** | Vertical (⬇️) | Vertical (Y-axis) | Horizontal (X-axis) |
| **Row** | Horizontal (➡️) | Horizontal (X-axis) | Vertical (Y-axis) |

By combining `Row` and `Column` (such as nesting a `Row` of skills inside a `Column` of profile details, as done in your app), you can build complex UI layouts in Flutter!

## 3. Example Code
I have created a dedicated example file for you located at `app/lib/examples/row_column_example.dart`. It demonstrates how to combine `Row` and `Column` in a single screen.

Here is the code:
```dart
import 'package:flutter/material.dart';

class RowColumnExample extends StatelessWidget {
  const RowColumnExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Row & Column Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // Column main axis is vertical, cross axis is horizontal
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch horizontally
          children: [
            const Text(
              'This is a Column (Vertical)',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            // A Row nested inside a Column
            Container(
              color: Colors.blue.shade50,
              padding: const EdgeInsets.all(16),
              child: const Row(
                // Row main axis is horizontal, cross axis is vertical
                mainAxisAlignment: MainAxisAlignment.spaceAround, // Space out horizontally
                crossAxisAlignment: CrossAxisAlignment.center, // Center vertically within the row
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 40),
                  Text(
                    'This is a Row (Horizontal)',
                    style: TextStyle(fontSize: 18),
                  ),
                  Icon(Icons.star, color: Colors.amber, size: 40),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Another Row to show button alignment
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Left'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Center'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Right'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

### How to use it:
To see this example in your app, open `app/lib/main.dart` and update your `home` property to call `RowColumnExample()` instead of your current widget.

```dart
import 'package:flutter/material.dart';
import 'examples/row_column_example.dart'; // Add this import

void main() {
  runApp(
    MaterialApp(
      home: const RowColumnExample(), // Update this line
    ),
  );
}
```
