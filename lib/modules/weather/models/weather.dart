class WeatherData {
  Coord? coord;
  List<Weather>? weather;
  String base = '';
  Main? main;
  int visibility = 0;
  Wind? wind;
  Clouds? clouds;
  int dt = 0;
  Sys? sys;
  int timezone = 0;
  int id = 0;
  String name = '';
  int cod = 0;

  WeatherData(
      {this.coord,
      this.weather,
      this.base = '',
      this.main,
      this.visibility = 0,
      this.wind,
      this.clouds,
      this.dt = 0,
      this.sys,
      this.timezone = 0,
      this.id = 0,
      this.name = '',
      this.cod = 0});

  WeatherData.fromJson(Map<String, dynamic> json) {
    coord = json['coord'] != null ? Coord.fromJson(json['coord']) : Coord();
    if (json['weather'] != null) {
      weather = <Weather>[];
      json['weather'].forEach((v) {
        weather!.add(Weather.fromJson(v));
      });
    } else {
      weather = <Weather>[];
    }
    base = json['base'] ?? '';
    main = json['main'] != null ? Main.fromJson(json['main']) : Main();
    visibility = json['visibility'] ?? 0;
    wind = json['wind'] != null ? Wind.fromJson(json['wind']) : Wind();
    clouds =
        json['clouds'] != null ? Clouds.fromJson(json['clouds']) : Clouds();
    dt = json['dt'] ?? -1;
    sys = json['sys'] != null ? Sys.fromJson(json['sys']) : Sys();
    timezone = json['timezone'] ?? 0;
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
    cod = json['cod'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (coord != null) {
      data['coord'] = coord!.toJson();
    }
    if (weather != null) {
      data['weather'] = weather!.map((v) => v.toJson()).toList();
    }
    data['base'] = base;
    if (main != null) {
      data['main'] = main!.toJson();
    }
    data['visibility'] = visibility;
    if (wind != null) {
      data['wind'] = wind!.toJson();
    }
    if (clouds != null) {
      data['clouds'] = clouds!.toJson();
    }
    data['dt'] = dt;
    if (sys != null) {
      data['sys'] = sys!.toJson();
    }
    data['timezone'] = timezone;
    data['id'] = id;
    data['name'] = name;
    data['cod'] = cod;
    return data;
  }
}

class Coord {
  double lon = 0;
  double lat = 0;

  Coord({this.lon = 0, this.lat = 0});

  Coord.fromJson(Map<String, dynamic> json) {
    lon = json['lon'] ?? 0;
    lat = json['lat'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lon'] = lon;
    data['lat'] = lat;
    return data;
  }
}

class Weather {
  int id = 800;
  String main = '';
  String description = '';
  String icon = '';

  Weather(
      {this.id = 800, this.main = '', this.description = '', this.icon = ''});

  Weather.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 800;
    main = json['main'] ?? '';
    description = json['description'] ?? '';
    icon = json['icon'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['main'] = main;
    data['description'] = description;
    data['icon'] = icon;
    return data;
  }
}

class Main {
  double temp = 0;
  double feelsLike = 0;
  double tempMin = 0;
  double tempMax = 0;
  int pressure = 0;
  int humidity = 0;
  int seaLevel = 0;
  int grndLevel = 0;

  Main(
      {this.temp = 0,
      this.feelsLike = 0,
      this.tempMin = 0,
      this.tempMax = 0,
      this.pressure = 0,
      this.humidity = 0,
      this.seaLevel = 0,
      this.grndLevel = 0});

  Main.fromJson(Map<String, dynamic> json) {
    temp = json['temp'] ?? 0;
    feelsLike = json['feels_like'] ?? 0;
    tempMin = json['temp_min'] ?? 0;
    tempMax = json['temp_max'] ?? 0;
    pressure = json['pressure'] ?? 0;
    humidity = json['humidity'] ?? 0;
    seaLevel = json['sea_level'] ?? 0;
    grndLevel = json['grnd_level'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['temp'] = temp;
    data['feels_like'] = feelsLike;
    data['temp_min'] = tempMin;
    data['temp_max'] = tempMax;
    data['pressure'] = pressure;
    data['humidity'] = humidity;
    data['sea_level'] = seaLevel;
    data['grnd_level'] = grndLevel;
    return data;
  }
}

class Wind {
  double speed = 0;
  int deg = 0;
  double gust = 0;

  Wind({this.speed = 0, this.deg = 0, this.gust = 0});

  Wind.fromJson(Map<String, dynamic> json) {
    speed = json['speed'] ?? 0;
    deg = json['deg'] ?? 0;
    gust = json['gust'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['speed'] = speed;
    data['deg'] = deg;
    data['gust'] = gust;
    return data;
  }
}

class Clouds {
  int all = 0;

  Clouds({this.all = 0});

  Clouds.fromJson(Map<String, dynamic> json) {
    all = json['all'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['all'] = all;
    return data;
  }
}

class Sys {
  String country = '';
  int sunrise = 0;
  int sunset = 0;

  Sys({this.country = '', this.sunrise = 0, this.sunset = 0});

  Sys.fromJson(Map<String, dynamic> json) {
    country = json['country'] ?? '';
    sunrise = json['sunrise'] ?? 0;
    sunset = json['sunset'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['country'] = country;
    data['sunrise'] = sunrise;
    data['sunset'] = sunset;
    return data;
  }
}
