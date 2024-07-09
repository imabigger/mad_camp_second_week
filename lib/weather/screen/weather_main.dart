import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import '../model/const.dart';

class WeatherMain extends StatefulWidget {
  const WeatherMain({super.key});

  @override
  State<WeatherMain> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherMain> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);

  Weather? _weather;
  Map<String, List<Weather>>? _groupedDailyWeather;
  String? _selectedDay;

  @override
  void initState() {
    super.initState();
    //여기에 위치 받아서 city를 업데이트 할 수 있도록 해야.
    getCurrentLocationAndFetchWeather();
  }

  Future<void> getCurrentLocationAndFetchWeather() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
      double late = position.latitude;
      double long = position.longitude;
      fetchWeather(late, long);
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<void> fetchWeather(double latitude, double longitude) async {
    try {
      Weather weather = await _wf.currentWeatherByLocation(latitude, longitude);
      List<Weather> forecast = await _wf.fiveDayForecastByLocation(latitude, longitude);
      Map<String, List<Weather>> groupedWeather = groupForecastByDay(forecast);

      setState(() {
        _weather = weather;
        _groupedDailyWeather = groupedWeather;
      });
    } catch (e) {
      print("Error fetching weather: $e");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_weather!.areaName!),
      ),

      drawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.green[800],
              ),
              accountName: Text('다른 지역 날씨'),
              accountEmail: Text('관심있는 지역의 날씨를 조회해보세요'),
              // currentAccountPicture: CircleAvatar(
              //   backgroundImage: AssetImage('assets/user.png'),
              // ),
            ),
            ListTile(
              leading: Icon(Icons.my_location),
              title: Text(_weather!.areaName!),
              onTap: () {
                // 홈 화면으로 이동
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                // This is important to make the row fit its content
                children: [
                  Image(image: NetworkImage("http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png"),),
                  SizedBox(width: 8),
                  Text("${_weather?.temperature?.celsius?.toStringAsFixed(0)}°C"),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.location_on_outlined),
              title: Text('길음동'),
              onTap: () {
                // 홈 화면으로 이동
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                // This is important to make the row fit its content
                children: [
                  Icon(Icons.cloud),
                  SizedBox(width: 8),
                  Text('23°C'),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.add_location),
              title: Text('관심 지역 추가'),
              onTap: () {
                // 설정 화면으로 이동
              },
            ),
            // 추가적인 사이드바 메뉴 아이템들
          ],
        ),
      ),

      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    if (_weather == null || _groupedDailyWeather == null) {
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
            //앱 바 다음으로 현재 날씨 보여주는 row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "${_weather?.temperature?.celsius?.toStringAsFixed(0)}°",
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
                      "${_weather?.tempMax?.celsius?.toStringAsFixed(
                          0)}° / ${_weather?.tempMin?.celsius?.toStringAsFixed(
                          0)}°",
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
                          "http://openweathermap.org/img/wn/${_weather
                              ?.weatherIcon}@4x.png"
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            //요일별 예보 보여주는 container
            _buildDailyForecast(),
            if (_selectedDay != null) _buildHourlyForecast(),
            SizedBox(height: 16),

            //일몰 일출과 오늘의 농사팁 - 커스텀 멘트 바꾸기
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

            //자외선지수 -> 다른 걸로 바꾸기, 습도, 바람
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
                        "${_weather?.humidity?.toStringAsFixed(0)}%",
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
                        '${_weather?.windSpeed?.toStringAsFixed(0)}m/s',
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

            //레이더 지도
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                    '레이더 및 지도\n이곳은 그냥 플레이스홀더',
                    style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold,),
                    textAlign: TextAlign.center),
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
                        _selectedDay = date;
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
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
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
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),),
                  child: Column(
                    children: [
                      Text(
                        timeStr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Image.network("http://openweathermap.org/img/wn/$icon@2x.png"),
                      SizedBox(height: 8),
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
    DateTime now = _weather!.date!;
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
    DateTime sunrise = _weather!.sunrise!;
    DateTime sunset = _weather!.sunset!;

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