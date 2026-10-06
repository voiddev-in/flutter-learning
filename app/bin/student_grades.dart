enum Status { active, inactive, blocked }

void main() {
  Status status = Status.active;
}
// enum Grade {
//   A(90),
//   B(80),
//   C(70),
//   D(60),
//   F(50);

//   // final int minScore;
//   // const Grade(this.minScore);
// }

// // Extension on Enum
// extension GradeExtension on Grade {
//   String get message {
//     switch (this) {
//       case Grade.A:
//         return 'Excellent';
//       case Grade.B:
//         return 'Good';
//       case Grade.C:
//         return 'Average';
//       case Grade.D:
//         return 'Poor';
//       case Grade.F:
//         return 'Fail';
//     }
//   }
// }

// // Student Class
// class Student {
//   final String name;
//   final int? score; // Nullable field ?

//   // late field
//   late final Grade grade;

//   Student({required this.name, this.score}) {
//     // using ?? to handle null
//     int effectiveScore = score ?? 0;

//     if (effectiveScore >= Grade.A.minScore) {
//       grade = Grade.A;
//     } else if (effectiveScore >= Grade.B.minScore) {
//       grade = Grade.B;
//     } else if (effectiveScore >= Grade.C.minScore) {
//       grade = Grade.C;
//     } else if (effectiveScore >= Grade.D.minScore) {
//       grade = Grade.D;
//     } else {
//       grade = Grade.F;
//     }
//   }

//   // using ! to force unwrap (use with caution, assumes score is never null when called)
//   int get requiredScore => score!;

//   @override
//   String toString() =>
//       '$name (Score: ${score ?? 'N/A'}, Grade: ${grade.name} - ${grade.message})';
// }

// // Filter function with named parameters and arrow function inside
// List<Student> filterStudents(
//   List<Student> students, {
//   Grade? minGrade,
//   int? exactScore,
// }) {
//   return students.where((s) {
//     if (minGrade != null) {
//       return s.grade.minScore >= minGrade.minScore;
//     }
//     if (exactScore != null) {
//       return (s.score ?? 0) == exactScore;
//     }
//     return true;
//   }).toList();
// }

// // Average function with optional positional parameter and arrow functions
// double calculateAverage(List<Student> students, [bool ignoreNulls = false]) {
//   var validStudents = students.where(
//     (s) => ignoreNulls ? s.score != null : true,
//   );
//   if (validStudents.isEmpty) return 0.0;

//   int total = validStudents.fold(0, (sum, s) => sum + (s.score ?? 0));
//   return total / validStudents.length;
// }

// // Arrow function for quick filtering
// List<Student> getPassingStudents(List<Student> students) =>
//     students.where((s) => s.grade != Grade.F).toList();

// void main() {
//   print('--- Student Grades App ---');

//   // Creating lists of students
//   final classA = [
//     Student(name: 'Alice', score: 95),
//     Student(name: 'Bob', score: null), // score is null
//   ];

//   final classB = [
//     Student(name: 'Charlie', score: 85),
//     Student(name: 'Diana', score: 75),
//     Student(name: 'Eve', score: 55),
//   ];

//   // List Spread Operator
//   final List<Student> allStudentsList = [...classA, ...classB];

//   // Set Spread Operator
//   final Set<Student> allStudentsSet = {...classA, ...classB};

//   // Map Spread Operator
//   final Map<String, Student> mapA = {for (var s in classA) s.name: s};
//   final Map<String, Student> mapB = {for (var s in classB) s.name: s};
//   final Map<String, Student> allStudentsMap = {...mapA, ...mapB};

//   print('\nAll Students (from List):');
//   for (var student in allStudentsList) {
//     print(student);
//   }

//   // Using the Set
//   print('\nTotal unique students (from Set): ${allStudentsSet.length}');

//   print('\n--- Nullable Operations (!, ?, ??, late) ---');
//   Student bob = allStudentsMap['Bob']!;
//   print('Bob\'s score with ?? -> ${bob.score ?? 0}');
//   try {
//     print(
//       'Bob\'s required score with ! -> ${bob.requiredScore}',
//     ); // Will throw exception
//   } catch (e) {
//     print('Caught exception using ! on null: $e');
//   }

//   print('\n--- Filtering with Named Parameters ---');
//   final topStudents = filterStudents(allStudentsList, minGrade: Grade.B);
//   print('Students with at least Grade B:');
//   topStudents.forEach((s) => print('  $s')); // Arrow function

//   print('\n--- Average Calculation with Optional Positional Parameters ---');
//   double avgWithNulls = calculateAverage(allStudentsList);
//   double avgWithoutNulls = calculateAverage(allStudentsList, true);

//   print('Average (treating null as 0): $avgWithNulls');
//   print('Average (ignoring nulls): $avgWithoutNulls');

//   print('\n--- Arrow Function Filter ---');
//   final passingStudents = getPassingStudents(allStudentsList);
//   print('Passing Students: ${passingStudents.map((s) => s.name).join(', ')}');
// }
