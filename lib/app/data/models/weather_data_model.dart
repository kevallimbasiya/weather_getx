
class Weather {
    Weather({
        this.coord,
        this.main,
        this.id,
        this.name,
        this.cod,
    });

    final Coord? coord;
    final Main? main;
    final int? id;
    final String? name;
    final int? cod;

    factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        coord: json["coord"] == null ? null : Coord.fromJson(json["coord"]),
        main: json["main"] == null ? null : Main.fromJson(json["main"]),
        id: json["id"],
        name: json["name"],
        cod: json["cod"],
    );

    Map<String, dynamic> toJson() => {
        "coord": coord?.toJson(),
        "main": main?.toJson(),
        "id": id,
        "name": name,
        "cod": cod,
    };
}



class Coord {
    Coord({
        this.lon,
        this.lat,
    });

    final double? lon;
    final double? lat;

    factory Coord.fromJson(Map<String, dynamic> json) => Coord(
        lon: json["lon"]?.toDouble(),
        lat: json["lat"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "lon": lon,
        "lat": lat,
    };
}

class Main {
    Main({
        this.temp,
        this.feelsLike,
        this.tempMin,
        this.tempMax,
        this.pressure,
        this.humidity,
    });

    final double? temp;
    final double? feelsLike;
    final double? tempMin;
    final double? tempMax;
    final int? pressure;
    final int? humidity;

    factory Main.fromJson(Map<String, dynamic> json) => Main(
        temp: json["temp"]?.toDouble(),
        feelsLike: json["feels_like"]?.toDouble(),
        tempMin: json["temp_min"]?.toDouble(),
        tempMax: json["temp_max"]?.toDouble(),
        pressure: json["pressure"],
        humidity: json["humidity"],
    );

    Map<String, dynamic> toJson() => {
        "temp": temp,
        "feels_like": feelsLike,
        "temp_min": tempMin,
        "temp_max": tempMax,
        "pressure": pressure,
        "humidity": humidity,
    };
}

