class TODOItem {
  String title;
  String description;
  bool isdone;

  TODOItem({
    required this.title,
    required this.description,
    this.isdone = false,
  });

  void toggeldone() {
    isdone = !isdone;
  }
}
