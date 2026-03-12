class Student {
  String name;
  double ca;
  double exam;
  double total;
  String grade;

  Student({
    required this.name,
    required this.ca,
    required this.exam,
    this.grade = "",
  }) : total = ca + exam;
}
