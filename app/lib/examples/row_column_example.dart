import 'package:flutter/material.dart';

class RowColumnLesson extends StatelessWidget {
  const RowColumnLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Row & Column Examples'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        color: Colors.grey.shade200,
        width: double.infinity,
        
        // =========================================================
        // Just comment this out and uncomment the next example you want to show!
        // =========================================================

        // --- EXAMPLE 1: Basic Column (Vertical Stacking) ---
        child: Column(
          children: const [
            Icon(Icons.sentiment_very_satisfied, size: 50, color: Colors.blue),
            Icon(Icons.sentiment_satisfied, size: 50, color: Colors.green),
            Icon(Icons.sentiment_neutral, size: 50, color: Colors.orange),
          ],
        ),

        /*
        // --- EXAMPLE 2: Column with MainAxisAlignment ---
        // 'mainAxisAlignment' on a Column controls vertical spacing.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
          children: const [
            Icon(Icons.sentiment_very_satisfied, size: 50, color: Colors.blue),
            Icon(Icons.sentiment_satisfied, size: 50, color: Colors.green),
            Icon(Icons.sentiment_neutral, size: 50, color: Colors.orange),
          ],
        ),
        */

        /*
        // --- EXAMPLE 3: Column with CrossAxisAlignment ---
        // 'crossAxisAlignment' on a Column controls horizontal alignment.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          crossAxisAlignment: CrossAxisAlignment.end,  // Align to the right horizontally
          children: const [
            Text('Short text', style: TextStyle(fontSize: 20)),
            Text('A bit longer text', style: TextStyle(fontSize: 20)),
            Text('The longest text in the column', style: TextStyle(fontSize: 20)),
          ],
        ),
        */

        /*
        // --- EXAMPLE 4: Basic Row (Horizontal Stacking) ---
        // A Row places its children side-by-side from left to right.
        child: Row(
          children: const [
            Icon(Icons.directions_car, size: 50, color: Colors.red),
            Icon(Icons.directions_bike, size: 50, color: Colors.green),
            Icon(Icons.directions_walk, size: 50, color: Colors.blue),
          ],
        ),
        */

        /*
        // --- EXAMPLE 5: Row with MainAxisAlignment ---
        // 'mainAxisAlignment' on a Row controls horizontal spacing.
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space them out
          children: const [
            Icon(Icons.directions_car, size: 50, color: Colors.red),
            Icon(Icons.directions_bike, size: 50, color: Colors.green),
            Icon(Icons.directions_walk, size: 50, color: Colors.blue),
          ],
        ),
        */

        /*
        // --- EXAMPLE 6: Nesting a Row inside a Column ---
        // You can build complex layouts by putting Rows in Columns!
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Choose your vehicle:', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: (){}, child: const Text('Car')),
                ElevatedButton(onPressed: (){}, child: const Text('Bike')),
                ElevatedButton(onPressed: (){}, child: const Text('Walk')),
              ],
            ),
          ],
        ),
        */
      ),
    );
  }
}
