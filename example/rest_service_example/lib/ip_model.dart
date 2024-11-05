// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class IPModel {
  final String country;
  final String city;
  final double lat;
  final double long;
  final String timezone;

  IPModel({
    required this.country,
    required this.city,
    required this.lat,
    required this.long,
    required this.timezone,
  });

  IPModel copyWith({
    String? country,
    String? city,
    double? lat,
    double? long,
    String? timezone,
  }) {
    return IPModel(
      country: country ?? this.country,
      city: city ?? this.city,
      lat: lat ?? this.lat,
      long: long ?? this.long,
      timezone: timezone ?? this.timezone,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'country': country,
      'city': city,
      'lat': lat,
      'long': long,
      'timezone': timezone,
    };
  }

  factory IPModel.fromMap(Map<String, dynamic> map) {
    return IPModel(
      country: map['country'] as String,
      city: map['city'] as String,
      lat: map['lat'] as double,
      long: map['lon'] as double,
      timezone: map['timezone'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory IPModel.fromJson(String source) =>
      IPModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'IP Data:\ncountry: $country, \ncity: $city, \nlat: $lat, \nlong: $long, \ntimezone: $timezone';
  }

  @override
  bool operator ==(covariant IPModel other) {
    if (identical(this, other)) return true;

    return other.country == country &&
        other.city == city &&
        other.lat == lat &&
        other.long == long &&
        other.timezone == timezone;
  }

  @override
  int get hashCode {
    return country.hashCode ^
        city.hashCode ^
        lat.hashCode ^
        long.hashCode ^
        timezone.hashCode;
  }
}
