import 'package:flutter/material.dart';

/// --------------------------------------------------------------------------
/// Flutter: Widgets & the Widget Tree - Lesson Examples
/// --------------------------------------------------------------------------

/// This is the entry point example from Section 13.
/// To run this, you can change your main.dart to call:
/// runApp(const WidgetsLessonApp());
class WidgetsLessonApp extends StatelessWidget {
  const WidgetsLessonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Widgets & Widget Tree',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // We can easily swap the home widget to see different examples
      home: const MainLessonScreen(),
    );
  }
}

class MainLessonScreen extends StatelessWidget {
  const MainLessonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My App"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Hello Lohith"),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: const Text("Click Me")),
            const Divider(height: 40),
            const Text(
              "Other Examples:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onProfilePressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreenExample(),
                  ),
                );
              },
              child: const Text("View Profile Screen (Composition)"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreenExample(),
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CounterScreenExample(),
                  ),
                );
              },
              child: const Text("View Counter (State & build)"),
            ),
          ],
        ),
      ),
    );
  }
}

/// --------------------------------------------------------------------------
/// 1. Widget Composition Example (Section 4)
/// Breaking a large screen into smaller, reusable widgets.
/// --------------------------------------------------------------------------

class ProfileScreenExample extends StatelessWidget {
  const ProfileScreenExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile Screen - Composition")),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProfileHeader(),
            SizedBox(height: 20),
            UserDetails(),
            SizedBox(height: 20),
            SkillsSection(),
            Spacer(),
            ContactButton(),
          ],
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
        SizedBox(height: 10),
        Text(
          "john",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text("Flutter Developer"),
      ],
    );
  }
}

class UserDetails extends StatelessWidget {
  const UserDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          "Passionate about building beautiful cross-platform applications using Flutter.",
        ),
      ),
    );
  }
}

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Skills",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Chip(label: Text("Dart")),
            Chip(label: Text("Flutter")),
            Chip(label: Text("Firebase")),
          ],
        ),
      ],
    );
  }
}

class ContactButton extends StatelessWidget {
  const ContactButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () {}, child: const Text("Contact Me"));
  }
}

/// --------------------------------------------------------------------------
/// 2. The build() method and State Example (Section 11)
/// --------------------------------------------------------------------------

class CounterScreenExample extends StatelessWidget {
  const CounterScreenExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Counter - State & Build")),
      body: const Center(child: Counter()),
    );
  }
}

class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("You have pushed the button this many times:"),
        Text(
          "$count",
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              count++;
            });
          },
          child: const Text("Increase"),
        ),
      ],
    );
  }
}

/// --------------------------------------------------------------------------
/// 3. Custom Widget Example (Section 9)
/// --------------------------------------------------------------------------

class WelcomeMessage extends StatelessWidget {
  const WelcomeMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Welcome Lohith",
      style: TextStyle(fontSize: 20, color: Colors.blue),
    );
  }
}

class CustomWidgetExample extends StatelessWidget {
  const CustomWidgetExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Custom Widget")),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [WelcomeMessage(), Text("Flutter Developer")],
        ),
      ),
    );
  }
}
