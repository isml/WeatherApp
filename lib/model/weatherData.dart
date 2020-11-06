class WeatherData {
  final String date;
  final String day;
  final String icon;
  final String description;
  final String status;
  final String degree;
  final String min;
  final String max;
  final String night;
  final String humidity;

  WeatherData({
    this.date,
    this.day,
    this.icon,
    this.description,
    this.status,
    this.degree,
    this.min,
    this.max,
    this.night,
    this.humidity,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
        date: json['date'],
        day: json['day'],
        icon: json['icon'],
        description: json['description'],
        status: json['status'],
        degree: json['degree'],
        min: json['min'],
        max: json['max'],
        night: json['night'],
        humidity: json['humidity']);
  }
}
