import 'package:flutter/material.dart';


class CommunityWritePage extends StatelessWidget {
  const CommunityWritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: '묻고 답해요',
            icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
            items: <String>['묻고 답해요', '함께해요', '판매해요', '농담 이야기']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              // 드롭다운 변경 시 동작 추가
            },
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // 등록 버튼 클릭 시 동작 추가
            },
            child: const Text(
              '등록',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextField(
              decoration: InputDecoration(
                hintText: '제목을 입력해주세요.',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      hintText: '(선택) 서비스',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                    ),
                    items: <String>['서비스1', '서비스2', '서비스3'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {},
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      hintText: '(선택) 지역',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                    ),
                    items: <String>['지역1', '지역2', '지역3'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: TextField(
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: '농사와 관련해 궁금했던 모든 것을 물어보세요.\n\n'
                      '예) 작은 텃밭을 가꿔보려 하는데 뭘 심을까요?\n'
                      '예) 프리지아는 어떤 환경에서 잘 자라나요?',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              '• 주제에 맞지 않는 글이나 커뮤니티 이용정책에 위배되는 글은 신고의 대상이 됩니다.\n'
                  '• 일정 수 이상의 신고를 받으면 작성한 글이 숨김 및 삭제될 수 있습니다.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () {
                    // 카메라 버튼 클릭 시 동작 추가
                  },
                ),
                const Text('0/15'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
