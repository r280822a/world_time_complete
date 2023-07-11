class WorldTime {
  String timezone;
  String flag; // Flag URL
  String continent;
  bool isDay = true;
  late Duration offset; // Offset from local time

  // Constructor, requiring each attribute to be explicitly named
  WorldTime({required this.timezone, required this.flag, required this.continent});

  Future<void> initOffset(int localTimestamp, int zoneTimestamp) async {
    // Initialize appropriate offset for class timezone
    // Initialize variables
    DateTime zoneDatetime = DateTime.now();
    DateTime localDatetime = zoneDatetime;

    // Get local date time
    localDatetime = DateTime.fromMillisecondsSinceEpoch(localTimestamp * 1000);
    // Get class timezone date time
    zoneDatetime = DateTime.fromMillisecondsSinceEpoch(zoneTimestamp * 1000);

    // Offset is the difference between local timezone and class timezone
    offset = zoneDatetime.difference(localDatetime);
  }
}
