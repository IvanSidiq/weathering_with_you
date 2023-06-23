class City {
  String name = '';
  double lat = 0;
  double lon = 0;
  String country = '';
  String state = '';

  City(
      {this.name = '',
      this.lat = 0,
      this.lon = 0,
      this.country = '',
      this.state = ''});

  City.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    lat = json['lat'] ?? 0;
    lon = json['lon'] ?? 0;
    country = json['country'] ?? '';
    state = json['state'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['lat'] = lat;
    data['lon'] = lon;
    data['country'] = country;
    data['state'] = state;
    return data;
  }
}
