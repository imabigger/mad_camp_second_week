import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

final String OPENWEATHER_API_KEY = dotenv.env['OPENWEATHER_API_KEY']!;

Future<List<String>> fetchCities(String query) async {
  final response = await http.get(Uri.parse(
      'http://api.openweathermap.org/data/2.5/find?q=$query&type=like&appid=$OPENWEATHER_API_KEY'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> cities = data['list'];
    return cities.map((city) => city['name'] as String).toList();
  } else {
    throw Exception('Failed to load cities');
  }
}

class WeatherMain extends StatefulWidget {
  const WeatherMain({super.key});

  @override
  State<WeatherMain> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherMain> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);

  Weather? _currentLocationWeather; // 현재 위치의 날씨 정보
  Weather? _displayedWeather; // 화면에 표시할 날씨 정보
  Map<String, List<Weather>>? _groupedDailyWeather;
  String? _selectedDay;

  String? radarUrl;

  List<String> _favoriteCities = [];
  Map<String, Weather> _weatherInfo = {}; // 도시별 날씨 정보를 저장할 맵
  Set<String> _loadingCities = {}; // 로딩 중인 도시를 추적

  @override
  void initState() {
    super.initState();
    getCurrentLocationAndFetchWeather();
    fetchFavoriteCitiesWeather();
  }

  Future<void> getCurrentLocationAndFetchWeather() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    double latitude = position.latitude;
    double longitude = position.longitude;

    await fetchWeather(latitude, longitude);
    await _fetchRadarImage(latitude, longitude);
  }

  TileCoordinates latLonToTile(double lat, double lon, int zoom) {
    int x = ((lon + 180) / 360 * pow(2, zoom)).floor();
    int y = ((1 - log(tan(lat * pi / 180) + 1 / cos(lat * pi / 180)) / pi) / 2 * pow(2, zoom)).floor();
    return TileCoordinates(x, y);
  }

  Future<void> _fetchRadarImage(double lat, double lon) async {
    String apiKey = OPENWEATHER_API_KEY;
    int zoom = 5;
    TileCoordinates tile = latLonToTile(lat, lon, zoom);
    String url = 'https://tile.openweathermap.org/map/precipitation_new/$zoom/${tile.x}/${tile.y}.png?appid=$apiKey';
    setState(() {
      radarUrl = url;
    });
  }

  Future<void> fetchWeather(double latitude, double longitude) async {
    try {
      Weather weather = await _wf.currentWeatherByLocation(latitude, longitude);
      List<Weather> forecast = await _wf.fiveDayForecastByLocation(latitude, longitude);
      Map<String, List<Weather>> groupedWeather = groupForecastByDay(forecast);

      setState(() {
        _currentLocationWeather = weather;
        _displayedWeather = weather;
        _groupedDailyWeather = groupedWeather;
      });
    } catch (e) {
      print("Error fetching weather: $e");
    }
  }

  Future<void> fetchWeatherByCityName(String cityName) async {
    try {
      setState(() {
        _loadingCities.add(cityName);
      });

      Weather weather = await _wf.currentWeatherByCityName(cityName);
      List<Weather> forecast = await _wf.fiveDayForecastByCityName(cityName);
      Map<String, List<Weather>> groupedWeather = groupForecastByDay(forecast);

      setState(() {
        _weatherInfo[cityName] = weather;
        _displayedWeather = weather;
        _groupedDailyWeather = groupedWeather;
        _loadingCities.remove(cityName);
      });
    } catch (e) {
      setState(() {
        _loadingCities.remove(cityName);
      });
      print("Error fetching weather for $cityName: $e");
    }
  }

  Future<void> fetchFavoriteCitiesWeather() async {
    for (String city in _favoriteCities) {
      await fetchWeatherByCityName(city);
    }
  }

  Map<String, List<Weather>> groupForecastByDay(List<Weather> forecast) {
    Map<String, List<Weather>> groupedWeather = {};
    for (var weather in forecast) {
      String date = DateFormat('yyyy-MM-dd').format(weather.date!);
      if (!groupedWeather.containsKey(date)) {
        groupedWeather[date] = [];
      }
      groupedWeather[date]!.add(weather);
    }
    return groupedWeather;
  }

  void _showAddCityDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddCityDialog(
          onCityAdded: (city) async {
            setState(() {
              _favoriteCities.add(city);
            });
            await fetchWeatherByCityName(city);
          },
        );
      },
    );
  }

  void _showDeleteCityDialog(String city) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('삭제 확인'),
          content: Text('정말로 $city을(를) 삭제하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('삭제'),
              onPressed: () {
                setState(() {
                  _favoriteCities.remove(city);
                  _weatherInfo.remove(city);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_displayedWeather?.areaName ?? '날씨 정보를 불러오는 중...'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green[800],
              ),
              accountName: Text('다른 지역 날씨'),
              accountEmail: Text('관심있는 지역의 날씨를 조회해보세요'),
            ),
            ListTile(
              leading: Icon(Icons.my_location),
              title: Text(_currentLocationWeather?.areaName ?? '현재 위치 불러오는 중'),
              onTap: () async {
                if (_currentLocationWeather != null) {
                  await fetchWeather(
                    _currentLocationWeather!.latitude!,
                    _currentLocationWeather!.longitude!,
                  );
                  setState(() {
                    _displayedWeather = _currentLocationWeather;
                  });
                }
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_currentLocationWeather?.weatherIcon != null)
                    Image.network(
                      "http://openweathermap.org/img/wn/${_currentLocationWeather?.weatherIcon}@4x.png",
                    ),
                  SizedBox(width: 8),
                  Text("${_currentLocationWeather?.temperature?.celsius?.toStringAsFixed(0)}°C"),
                ],
              ),
            ),
            ..._favoriteCities.map((city) {
              final weather = _weatherInfo[city];
              return ListTile(
                leading: Icon(Icons.location_on_outlined),
                title: Text(city),
                onTap: () async {
                  await fetchWeatherByCityName(city);
                },
                trailing: _loadingCities.contains(city)
                    ? CircularProgressIndicator()
                    : weather != null
                    ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (weather.weatherIcon != null)
                      Image.network(
                        "http://openweathermap.org/img/wn/${weather.weatherIcon}@4x.png",
                      ),
                    SizedBox(width: 8),
                    Text("${weather.temperature?.celsius?.toStringAsFixed(0)}°C"),
                  ],
                )
                    : Icon(Icons.error),
                onLongPress: () {
                  _showDeleteCityDialog(city);
                },
              );
            }).toList(),
            ListTile(
              leading: Icon(Icons.add_location),
              title: Text('관심 지역 추가'),
              onTap: _showAddCityDialog,
            ),
          ],
        ),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    if (_displayedWeather == null || _groupedDailyWeather == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "${_displayedWeather?.temperature?.celsius?.toStringAsFixed(0)}°",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${_displayedWeather?.tempMax?.celsius?.toStringAsFixed(0)}° / ${_displayedWeather?.tempMin?.celsius?.toStringAsFixed(0)}°",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    _dateTimeInfo(),
                  ],
                ),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          "http://openweathermap.org/img/wn/${_displayedWeather?.weatherIcon}@4x.png"
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildDailyForecast(),
            if (_selectedDay != null)
              Column(
                children: [
                SizedBox(height: 16),
                _buildHourlyForecast()
                ],
              ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '오늘의 농사 팁',
                    style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold,),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '며칠간 비가 올 예정이니 배수로 확보를 잘 해두세요!', //이거 날씨에 맞게 !!
                    style: TextStyle(fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  _sunInfo(),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.wb_sunny, size: 36, color: Colors.orange),
                  Column(
                    children: [
                      Text(
                        '자외선지수', //일단은 다른 API 써야 해서 ..
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '낮음(0)',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 50,
                    child: VerticalDivider(color: Colors.green, thickness: 1),
                  ),
                  Icon(Icons.opacity, size: 36, color: Colors.blue),
                  Column(
                    children: [
                      Text(
                        '습도',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${_displayedWeather?.humidity?.toStringAsFixed(0)}%",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 50,
                    child: VerticalDivider(color: Colors.green, thickness: 1),
                  ),
                  Icon(Icons.air, size: 36, color: Colors.grey),
                  Column(
                    children: [
                      Text(
                        '바람',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${_displayedWeather?.windSpeed?.toStringAsFixed(0)}m/s',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      '기상 레이더',
                      style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold,),
                      textAlign: TextAlign.center),
                  SizedBox(height: 8),
                  radarUrl == null
                      ? CircularProgressIndicator()
                      : Image.network(radarUrl!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyForecast() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '요일별 예보',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ), textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _groupedDailyWeather!.keys.map((date) {
                List<Weather> dayWeather = _groupedDailyWeather![date]!;
                Weather firstWeather = dayWeather.first;
                String dayStr = DateFormat('E').format(firstWeather.date!);
                int tempMax = dayWeather.map((w) => w.tempMax!.celsius!).reduce((a, b) => a > b ? a : b).toInt();
                int tempMin = dayWeather.map((w) => w.tempMin!.celsius!).reduce((a, b) => a < b ? a : b).toInt();
                String icon = firstWeather.weatherIcon!;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_selectedDay == date) {
                        _selectedDay = null;
                      } else {
                        _selectedDay = date;
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _selectedDay == date ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          dayStr,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Image.network("http://openweathermap.org/img/wn/$icon@2x.png"),
                        SizedBox(height: 4),
                        Text('$tempMax° $tempMin°'),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyForecast() {
    List<Weather> hourlyWeather = _groupedDailyWeather![_selectedDay]!;
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: hourlyWeather.map((weather) {
                DateTime time = weather.date!;
                String timeStr = DateFormat('jm').format(time);
                int temp = weather.temperature!.celsius!.toInt();
                String icon = weather.weatherIcon!;
                return Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),),
                  child: Column(
                    children: [
                      Text(
                        timeStr,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Image.network("http://openweathermap.org/img/wn/$icon@2x.png"),
                      Text('$temp°'),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateTimeInfo() {
    DateTime now = _displayedWeather!.date!;
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          DateFormat("E").format(now) + ", " + DateFormat("h:mm a").format(now),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _sunInfo() {
    DateTime sunrise = _displayedWeather!.sunrise!;
    DateTime sunset = _displayedWeather!.sunset!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Image.asset("assets/weathers/sunrise.png", width: 50, height: 50,),
        Column(
          children: [
            Text('일출'),
            Text(DateFormat("h:mm a").format(sunrise),),
          ],
        ),
        Icon(Icons.arrow_forward),
        Column(
          children: [
            Text('일몰'),
            Text(DateFormat("h:mm a").format(sunset),),
          ],
        ),
        Image.asset("assets/weathers/sunset.png", width: 50, height: 50,),
      ],
    );
  }
}

class AddCityDialog extends StatefulWidget {
  final Function(String) onCityAdded;

  const AddCityDialog({Key? key, required this.onCityAdded}) : super(key: key);

  @override
  _AddCityDialogState createState() => _AddCityDialogState();
}

class _AddCityDialogState extends State<AddCityDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];

  void _searchCity() async {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      try {
        final results = await fetchCities(query);
        setState(() {
          _searchResults = results;
        });
      } catch (e) {
        print("Error searching for cities: $e");
      }
    }
  }

  void _addCity(String city) {
    widget.onCityAdded(city);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('관심 지역 추가'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search City',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchCity,
                ),
              ),
            ),
            SizedBox(height: 8),
            ..._searchResults.map((city) => ListTile(
              title: Text(city),
              onTap: () => _addCity(city),
            )).toList(),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('취소'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class TileCoordinates {
  final int x;
  final int y;
  TileCoordinates(this.x, this.y);
}
