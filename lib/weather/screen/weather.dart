import 'package:flutter/material.dart';

class WeatherPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('구성동'),
        ),

      drawer: Drawer(
          child: Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                decoration: BoxDecoration( color: Colors.green[800],
                ),
                accountName: Text('다른 지역 날씨'),
                accountEmail: Text('관심있는 지역의 날씨를 조회해보세요'),
                // currentAccountPicture: CircleAvatar(
                //   backgroundImage: AssetImage('assets/user.png'),
                // ),
              ),
              ListTile(
                leading: Icon(Icons.my_location),
                title: Text('구성동'),
                onTap: () {
                  // 홈 화면으로 이동
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,  // This is important to make the row fit its content
                  children: [
                    Icon(Icons.cloud),
                    SizedBox(width: 8),
                    Text('25°C'),
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
                  mainAxisSize: MainAxisSize.min,  // This is important to make the row fit its content
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

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    '25°C',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '31° / 23°',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        '금, 오후 10:00',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.nights_stay, size: 48),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Handle 기온 click
                            print('기온 clicked');
                          },
                          child: Text(
                            '기온',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline, // Optional: to show it's clickable
                            ),
                          ),
                        ),
                        Text(' | '),
                        GestureDetector(
                          onTap: () {
                            // Handle 강수확률 click
                            print('강수확률 clicked');
                          },
                          child: Text(
                            '강수확률',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline, // Optional: to show it's clickable
                            ),
                          ),
                        ),
                        Text(' | '),
                        GestureDetector(
                          onTap: () {
                            // Handle 대기질 click
                            print('대기질 clicked');
                          },
                          child: Text(
                            '대기질',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline, // Optional: to show it's clickable
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(7, (index) {
                        return Column(
                          children: [
                            Text('오후 10시'),
                            Text('4%'),
                          ],
                        );
                      }),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(7, (index) {
                        return GestureDetector(
                          onTap: () {
                            // Handle day click
                            print('${['금', '토', '일', '월', '화', '수', '목'][index]} clicked');
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: index == 0 ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  ['금', '토', '일', '월', '화', '수', '목'][index],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Icon(Icons.wb_sunny), // Replace with the appropriate weather icons
                                SizedBox(height: 8),
                                Text('29° 23°'),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ), //배경색 바꾸는 거 물어보기
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
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '며칠간 비가 올 예정이니 배수로 확보를 잘 해두세요!',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.wb_sunny),
                        Column(
                          children: [
                            Text('일출'),
                            Text('오전 5:19'),
                          ],
                        ),
                        Icon(Icons.arrow_forward),
                        Column(
                          children: [
                            Text('일몰'),
                            Text('오후 7:52'),
                          ],
                        ),
                        Icon(Icons.brightness_3),
                      ],
                    ),
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
                          '자외선지수',
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
                          '76%',
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
                          '1m/s',
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
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                      '레이더 및 지도\n이곳은 그냥 플레이스홀더',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
                      textAlign: TextAlign.center),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: '커뮤니티',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sunny),
            label: '날씨',
          ),
        ],
      ),

    );
  }
}