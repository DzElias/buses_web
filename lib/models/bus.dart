// To parse this JSON data, do
//
//     final bus = busFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Bus busFromMap(String str) => Bus.fromMap(json.decode(str));

String busToMap(Bus data) => json.encode(data.toMap());

class Bus {
    Bus({
        required this.id,
        required this.company,
        required this.line,
        required this.stops,
        required this.nextStop,
        required this.firstStop,
        required this.lastStop,
        required this.latitude,
        required this.longitude,
        required this.ruta,
        required this.vehiculeNumber,
        required this.actualDriver
    });

    String id;
    String company;
    String line;
    List<String> stops;
    String nextStop;
    String firstStop;
    String lastStop;
    double latitude;
    double longitude;
    String ruta;
    String vehiculeNumber;
    String? actualDriver; 


    factory Bus.fromMap(Map<String, dynamic> json) => Bus(
        id: json["_id"],
        company: json["company"],
        line: json["line"],
        stops: List<String>.from(json["stops"].map((x) => x)),
        firstStop: List<String>.from(json["stops"].map((x) => x)).first,
        lastStop: List<String>.from(json["stops"].map((x) => x)).last,
        nextStop: json["nextStop"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        ruta: json["ruta"],
        vehiculeNumber: json["num"],
        actualDriver: json["actualDriver"]
    );

    Map<String, dynamic> toMap() => {
        "_id": id,
        "company": company,
        "line": line,
        "stops": List<dynamic>.from(stops.map((x) => x)),
        "nextStop": nextStop,
        "firstStop": firstStop,
        "lastStop": lastStop,
        "latitude": latitude,
        "longitude": longitude,
        "ruta": ruta,
        "num": vehiculeNumber,
        "actualDriver": actualDriver,
    };
}
