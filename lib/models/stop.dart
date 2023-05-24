// To parse this JSON data, do
//
//     final stop = stopFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Stop stopFromMap(String str) => Stop.fromMap(json.decode(str));

String stopToMap(Stop data) => json.encode(data.toMap());

class Stop {
    Stop({
        required this.id,
        required this.title,
        required this.latitude,
        required this.longitude,
        required this.waiting,
    });

    String id;
    String title;
    double latitude;
    double longitude;
    int waiting;

    factory Stop.fromMap(Map<String, dynamic> json) => Stop(
        id: json["_id"],
        title: json["title"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        waiting: json["waiting"],
    );

    Map<String, dynamic> toMap() => {
        "_id": id,
        "title": title,
        "latitude": latitude,
        "longitude": longitude,
        "waiting": waiting,
    };
}
