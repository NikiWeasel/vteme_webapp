class Regulation {
  Regulation({
    this.id,
    required this.name,
    required this.duration,
    required this.cost,
  });

  String? id;
  final String name;
  final int duration;
  final int cost;

  String getFormattedDuration() {
    double time = duration.toDouble();
    if (time >= 60) {
      time = time / 60;
    } else {
      return '${time.toInt()} мин';
    }

    int hours = time.toInt();
    int minutes = ((time - hours) * 60).toInt();

    String formattedDuration = '';
    if (hours == 0) {
      formattedDuration = '$minutes мин';
    }
    if (minutes == 0) {
      formattedDuration = '$hours ч';
    } else {
      formattedDuration = '$hours ч $minutes мин';
    }
    return formattedDuration;
  }
}
