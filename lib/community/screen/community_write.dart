import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kaist_summer_camp_second_week/auth/provider/auth_provider.dart';
import 'package:kaist_summer_camp_second_week/community/component/board.dart';
import 'package:kaist_summer_camp_second_week/community/provider/post_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class CommunityWritePage extends ConsumerStatefulWidget {
  const CommunityWritePage({super.key});

  @override
  ConsumerState<CommunityWritePage> createState() => _CommunityWritePageState();
}

class _CommunityWritePageState extends ConsumerState<CommunityWritePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  Board _selectedBoard = Board.questionAndAnswer;
  late String _selectedTopic = '';
  late String _selectedRegion = '';
  final ImagePicker _picker = ImagePicker();
  List<String> _imageBase64List = [];

  Future<void> _pickImage() async {
    if (await _requestPermissions()) {
      try {
        final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          final bytes = await File(pickedFile.path).readAsBytes();
          final base64String = base64Encode(bytes);
          setState(() {
            if (_imageBase64List.length < 15) {
              _imageBase64List.add('data:image/jpeg;base64,$base64String');
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('사진은 최대 15개까지 선택할 수 있습니다.')),
              );
            }
          });
        }
      } catch (e) {
        print("Error picking image: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이미지를 선택하는 중 오류가 발생했습니다.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('권한을 허용해야 합니다.')),
      );
    }
  }

  Future<bool> _requestPermissions() async {
    final statuses = await [
      Permission.camera,
      Permission.photos,
      Permission.storage,
    ].request();

    return statuses[Permission.camera]!.isGranted ||
        statuses[Permission.photos]!.isGranted ||
        statuses[Permission.storage]!.isGranted;
  }

  @override
  Widget build(BuildContext context) {
    print(_imageBase64List);
    // 키보드가 올라왔는지 여부를 판단하는 변수
    final bool isKeyboardVisible =
        MediaQuery.of(context).viewInsets.bottom != 0;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
            child: DropdownButton<Board>(
              value: _selectedBoard,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
              items: Board.values
                  .where((board) => board != Board.all)
                  .map((Board board) {
                return DropdownMenuItem<Board>(
                  value: board,
                  child: Text(
                    board.name,
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
              onChanged: (Board? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedBoard = newValue;
                    int selectedIndex = Board.values.indexOf(_selectedBoard);
                    print('Selected Index: $selectedIndex'); // Debug output
                  });
                }
              },
            ),
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                // 등록 버튼 클릭 시 동작 추가
                if(ref.read(authProvider).user == null) {
                  context.go('/auth');
                  return;
                }


                ref.read(postProvider.notifier).addPost(
                      content: _contentController.text,
                      title: _titleController.text,
                      boardId: Board.values.indexOf(_selectedBoard),
                      region: _selectedRegion,
                      topic: _selectedTopic,
                      images: _imageBase64List,
                    );
                context.pop();
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
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
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
                        hintText: '(선택) 토픽',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                      items: <String>['텃밭', '귀농', '농사'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        _selectedTopic = newValue!;
                      },
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
                      items: <String>[
                        '서울',
                        '부산',
                        '대구',
                        '인천',
                        '광주',
                        '대전',
                        '울산',
                        '세종',
                        '경기도',
                        '강원도',
                        '충청북도',
                        '충청남도',
                        '전라북도',
                        '전라남도',
                        '경상북도',
                        '경상남도',
                        '제주도'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        _selectedRegion = newValue!;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: TextField(
                  controller: _contentController,
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
              if (!isKeyboardVisible) ...[
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
                      onPressed: _pickImage,
                    ),
                    Text('${_imageBase64List.length}/15'),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
