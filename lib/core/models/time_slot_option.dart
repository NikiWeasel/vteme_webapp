class TimeSlotOption {
  final DateTime time;
  bool isSelected;

  TimeSlotOption({
    required this.time,
    this.isSelected = false,
  });

  @override
  String toString() {
    return '($time $isSelected)';
  }
}
