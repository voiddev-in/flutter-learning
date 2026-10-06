# Flutter: Widgets & the Widget Tree

| Topic | What you need to understand |
|---|---|
| **Everything is a Widget** | UI elements are represented using widgets |
| **Composition** | Build complex UI by putting widgets inside other widgets |
| **Widget Tree** | Flutter represents your UI as a hierarchy/tree of widgets |
| **`build()`** | A widget describes what its UI should look like |

---

## 1. Everything is a Widget

In Flutter, almost everything you see in the application is represented by a **widget**.

For example:

```dart
Text("Hello")
```

`Text` is a widget.

```dart
ElevatedButton(
  onPressed: () {},
  child: Text("Click Me"),
)
```

Both `ElevatedButton` and `Text` are widgets.

Even things that aren't directly visible can be widgets.

For example:

```dart
Padding(
  padding: EdgeInsets.all(20),
  child: Text("Hello"),
)
```

Here:
- `Padding` → widget
- `Text` → widget
- `EdgeInsets` → not a widget; it is configuration data

Another example:

```dart
Column(
  children: [
    Text("Name"),
    Text("Lohith"),
    ElevatedButton(
      onPressed: () {},
      child: Text("Submit"),
    ),
  ],
)
```

You can think of it as:

```text
Column
 ├── Text
 ├── Text
 └── ElevatedButton
      └── Text
```

That's the beginning of the **widget tree**.

---

## 2. What is a Widget?

A widget is basically a **description of part of your UI**.

For example:

```dart
Text("Hello")
```

doesn't mean:
> "Draw these pixels permanently on the screen."

It describes:
> "I want a text widget displaying `Hello`."

Flutter takes that description and handles the actual rendering.

This distinction is important.

Think of widgets as **instructions/blueprints for the UI**.

---

## 3. Widget Composition

This is another very important Flutter idea.

Instead of creating one giant widget that does everything, you **combine small widgets together**.

For example:

```dart
Container(
  child: Column(
    children: [
      Text("Lohith"),
      Text("Developer"),
      ElevatedButton(
        onPressed: () {},
        child: Text("Contact"),
      ),
    ],
  ),
)
```

You're composing widgets:

```text
Container
   ↓
Column
 ├── Text
 ├── Text
 └── ElevatedButton
        ↓
      Text
```

This is called **composition**.

### Simple definition

> **Composition = building a bigger UI by combining smaller widgets.**

This is one of the core ideas behind Flutter.

---

## 4. Why Composition is Important

Imagine you are building a profile screen.

You could write everything inside one massive widget:

```dart
Scaffold(
  body: ... // hundreds of lines
)
```

That's difficult to maintain.

Instead, break it into smaller widgets.

```text
ProfileScreen
 ├── ProfileHeader
 ├── UserDetails
 ├── SkillsSection
 └── ContactButton
```

And each section can itself contain more widgets.

For example:

```text
ProfileHeader
 ├── CircleAvatar
 ├── Text
 └── Text
```

This makes your application easier to:
- understand
- reuse
- debug
- maintain
- test

---

## 5. What is the Widget Tree?

The **widget tree** is simply the hierarchical structure of widgets in your UI.

Consider:

```dart
MaterialApp(
  home: Scaffold(
    appBar: AppBar(
      title: Text("My App"),
    ),
    body: Center(
      child: Text("Hello"),
    ),
  ),
)
```

The tree looks roughly like this:

```text
MaterialApp
   │
   └── Scaffold
        ├── AppBar
        │    └── Text
        │
        └── Center
             └── Text
```

So Flutter doesn't see your screen as just `"Hello"`. It sees a **hierarchy of widgets**.

---

## 6. Parent and Child Widgets

You'll frequently hear these terms.

For example:

```dart
Center(
  child: Text("Hello"),
)
```

Here:
```text
Center  <-- Parent
  ↓
Text    <-- Child
```

Another example:

```dart
Column(
  children: [
    Text("Hello"),
    Text("World"),
  ],
)
```

Here:
```text
Column  <-- Parent
 ├── Text <-- Child
 └── Text <-- Child
```

`Column` is the parent and both `Text` widgets are children.

---

## 7. `child` vs `children`

This is something you should understand early.

Some widgets accept **one child**:

```dart
Center(
  child: Text("Hello"),
)
```
Notice: `child:` (Only one widget)

Some widgets accept **multiple children**:

```dart
Column(
  children: [
    Text("Hello"),
    Text("World"),
    Text("Flutter"),
  ],
)
```
Notice: `children:` (That's a list of widgets)

So:
- `child` → one widget
- `children` → multiple widgets

---

## 8. What is `build()`?

Now we come to one of the most important concepts.

When you create a custom Flutter widget, you often write:

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("Hello");
  }
}
```

The important part is:
```dart
Widget build(BuildContext context)
```

The `build()` method describes **what UI this widget should provide**.

In this example, `return Text("Hello");` means:
> This widget's UI should be a `Text` widget displaying `"Hello"`.

---

## 9. Example of a Custom Widget

Suppose you write:

```dart
class WelcomeMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("Welcome Lohith");
  }
}
```

And then use it:

```dart
Column(
  children: [
    WelcomeMessage(),
    Text("Flutter Developer"),
  ],
)
```

The tree becomes:
```text
Column
 ├── WelcomeMessage
 │      └── Text
 │
 └── Text
```

Notice something interesting: `WelcomeMessage` itself doesn't directly draw text. Its `build()` method returns `Text("Welcome Lohith")`. So Flutter can build the UI hierarchy from that description.

---

## 10. Think of `build()` Like This

A useful mental model is:

```text
Widget
   ↓
build()
   ↓
returns another widget tree
   ↓
Flutter renders it
```

For example:

```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Hello"),
      ),
    );
  }
}
```

The `build()` method says:
```text
MyScreen
   ↓
Scaffold
   ↓
Center
   ↓
Text
```
That's what `build()` describes.

---

## 11. `build()` Does NOT Mean "Build Once"

This is a common beginner misunderstanding.

You might think:
> "The `build()` method runs once when the screen starts."

Not necessarily. Flutter can call `build()` again when the widget needs to be rebuilt.

For example, with a `StatefulWidget`, changing state can trigger rebuilding.

```dart
class Counter extends StatefulWidget {
  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("$count"),
        ElevatedButton(
          onPressed: () {
            setState(() {
              count++;
            });
          },
          child: Text("Increase"),
        ),
      ],
    );
  }
}
```

Initially: `count = 0`, `build()` returns `Text("0")`.
After pressing the button, `setState` runs, `count = 1`. Flutter rebuilds the relevant UI, and `build()` produces `Text("1")`.

---

## 12. Very Important Mental Model

Don't think:
> `build()` = manually drawing the UI

Think:
> `build()` = describing what the UI should be

For example:

```dart
Widget build(BuildContext context) {
  return Column(
    children: [
      Text("Hello"),
      Text("Welcome"),
    ],
  );
}
```

You're essentially telling Flutter:
> "This widget should currently be represented by this widget structure."

---

## 13. Full Example

Let's put everything together.

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("My App"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Hello Lohith"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                child: const Text("Click Me"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

The widget tree is approximately:

```text
MyApp
 └── MaterialApp
      └── Scaffold
           ├── AppBar
           │    └── Text
           │
           └── Center
                └── Column
                     ├── Text
                     ├── SizedBox
                     └── ElevatedButton
                          └── Text
```

---

## 14. One Very Important Flutter Principle

Flutter UI is **declarative**.

That means you generally describe:
> **What the UI should look like**

rather than manually telling Flutter:
> "Find this button, move it here, change its text, repaint this part..."

For example:

```dart
Text(
  isLoggedIn ? "Welcome" : "Please Login",
)
```

You're describing the desired UI based on the current state. Flutter handles the work of updating the rendered result.

---

## 15. The 3 Concepts You Should Remember

For your notes, remember this:

### 1. Everything is a Widget
```text
Text, Container, Row, Column, Scaffold, AppBar, Button, Padding, Center...
```
Most UI pieces are widgets.

### 2. Composition
```text
Small Widgets -> Combine them -> Larger Widget -> Combine again -> Complete Screen
```

### 3. `build()`
```text
build() -> returns a Widget -> that can contain more Widgets -> forming the Widget Tree
```

---

## 16. A Simple Analogy

Think of building a house with LEGO.

- A single LEGO block: `Text`
- A small group:
```text
Row
 ├── Text
 └── Icon
```
- A larger structure:
```text
Card
 └── Column
      ├── Text
      ├── Row
      └── Button
```

**Widgets are the LEGO pieces.**
**Composition is putting them together.**
**The widget tree is the complete LEGO structure.**
**`build()` describes the structure a widget should have.**

---

## One thing I want you to learn next

Before moving to layouts like `Row`, `Column`, and `Container`, make sure you can look at this:

```dart
Scaffold(
  body: Center(
    child: Column(
      children: [
        Text("Hello"),
        ElevatedButton(
          onPressed: () {},
          child: Text("Click"),
        ),
      ],
    ),
  ),
)
```

and immediately understand:

```text
Scaffold
 └── Center
      └── Column
           ├── Text
           └── ElevatedButton
                └── Text
```

Once that becomes natural, **Flutter becomes much easier to understand**.
