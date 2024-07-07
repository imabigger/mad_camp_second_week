
class Plant{
  final String name;
  final String imageUrl;
  final List<String> description;

  Plant({required this.name,required this.imageUrl,required this.description});
}

final SSalplant = Plant(
  name: '쌀',
  imageUrl: 'assets/images/rice.jpg',
  description: [
    '• 온도: 20~35도의 따뜻한 기후\n• 강수량: 강수량이 많거나 관개 시스템이 잘 갖춰진 지역\n• 일조량: 매일 최소 6~8시간 충분한 일조',
    '• 토양 유형: 점질토나 사질토\n• pH 수준: 중성 또는 약산성(pH 5.5~7.0) 토양\n• 배수와 보수: 물을 잘 보유하면서도 적절한 배수',
    '• 모판 준비: 좋은 품질의 종자 선택, 적절한 시기에 파종\n• 이앙: 모를 일정한 간격으로 이앙하여 균일한 생장 유도\n• 관리: 논을 잘 관리하여 생장 동안 충분한 수분 공급\n• 비료: 주기적 시비 작업',
    '• 수확 시기: 완전히 익은 시기에 수확\n• 건조: 수확한 쌀을 적절히 건조시켜 저장 중 품질 유지\n• 저장: 적정한 해충으로부터 보호하기 위한 조건',
  ],
);

final mealPlant = Plant(
  name: '밀',
  imageUrl: 'assets/images/wheat.jpg',
  description: [
    '• 온도: 15~25도의 온화한 기후\n• 강수량: 500~800mm의 강수량이 필요\n• 일조량: 6~8시간의 일조량이 필요',
    '• 토양 유형: 중토 또는 흙\n• pH 수준: 중성 또는 약산성(pH 5.5~7.0) 토양\n• 배수와 보수: 물을 잘 보유하면서도 적절한 배수',
    '• 모판 준비: 적절한 시기에 파종\n• 이앙: 모를 일정한 간격으로 이앙하여 균일한 생장 유도\n• 관리: 생장 동안 충분한 수분 공급\n• 비료: 주기적 시비 작업',
    '• 수확 시기: 완전히 익은 시기에 수확\n• 건조: 수확한 밀을 적절히 건조시켜 저장 중 품질 유지\n• 저장: 적정한 해충으로부터 보호하기 위한 조건',
  ],
);