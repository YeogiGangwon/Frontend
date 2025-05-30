import 'package:flutter/material.dart';

// 임시 알림 데이터
final List<Map<String, String>> _notifications = [
  {
    'title': '새로운 추천!',
    'body': '회원님을 위한 맞춤 추천이 도착했어요. 확인해보세요!',
    'time': '오전 10:00',
  },
  {
    'title': '이벤트 안내',
    'body': '강릉 커피 축제 특별 할인 쿠폰이 발급되었습니다.',
    'time': '어제',
  },
  {
    'title': '시스템 점검 안내',
    'body': '보다 나은 서비스 제공을 위해 시스템 점검이 예정되어 있습니다.',
    'time': '2일 전',
  },
];

class NotificationPopup extends StatelessWidget {
  const NotificationPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('알림'),
      content: SizedBox(
        width: double.maxFinite,
        child: _notifications.isEmpty
            ? const Center(child: Text('새로운 알림이 없습니다.'))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: _notifications.length,
                itemBuilder: (BuildContext context, int index) {
                  final notification = _notifications[index];
                  return ListTile(
                    leading: const Icon(Icons.notifications_active_outlined),
                    title: Text(notification['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(notification['body']!),
                    trailing: Text(notification['time']!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    onTap: () {
                      // TODO: 알림 선택 시 상세 페이지로 이동 또는 특정 액션 수행
                      Navigator.of(context).pop(); // 팝업 닫기
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("'${notification['title']}' 알림을 확인했습니다.")),
                      );
                    },
                  );
                },
              ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('모두 읽음으로 표시'), // Optional: Mark all as read
          onPressed: () {
            // TODO: 모든 알림 읽음 처리 로직
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('모든 알림을 읽음으로 표시했습니다.')),
            );
          },
        ),
        TextButton(
          child: const Text('닫기'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
} 