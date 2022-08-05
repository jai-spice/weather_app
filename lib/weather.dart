// data class - immuatable - rudimentary implementation
class Weather {
  final int queryCost;
  final double latitude;
  final double longitude;
  final String resolvedAddress;
  final String address;
  final String timezone;
  final double tzoffset;
  final String description;
  final Conditions currentConditions;

  const Weather(
    this.queryCost,
    this.latitude,
    this.longitude,
    this.resolvedAddress,
    this.address,
    this.timezone,
    this.tzoffset,
    this.description,
    this.currentConditions,
  );

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      json["queryCost"] as int,
      json["latitude"] as double,
      json["longitude"] as double,
      json["resolvedAddress"] as String,
      json["address"] as String,
      json["timezone"] as String,
      json["tzoffset"] as double,
      json["description"] as String,
      Conditions.fromJson(json["currentConditions"]),
    );
  }
}

class Conditions {
  final double temp;
  final double feelslike;

  const Conditions(this.temp, this.feelslike);

  // factory design pattern
  factory Conditions.fromJson(Map<String, dynamic> json) {
    return Conditions(
      json["temp"] as double,
      json["feelslike"] as double,
    );
  }
}
