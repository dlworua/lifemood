import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lifemood/main.dart';
import 'package:lifemood/view/pages/feeling/feeling_editor_page.dart';
import 'package:timezone/data/latest.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  tz.initializeTimeZones(); // 전 세계 시간대 데이터 불러오기
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  final ios = DarwinInitializationSettings();

  final settings = InitializationSettings(android: android, iOS: ios);

  // ✅ 단 한 번만 초기화
  await flutterLocalNotificationsPlugin.initialize(
    settings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      final payload = response.payload;
      if (payload != null && payload == 'navigate_to_record') {
        _notificationClickHandler?.call();
      } else if (payload == 'open_feeling_editor') {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => FeelingEditorPage(selectedDate: DateTime.now()),
          ),
        );
      }
    },
  );

  tz.initializeTimeZones(); // 시간대 설정
}

/// 외부에서 사용할 수 있는 알림 표시 함수
Future<void> showNotification() async {
  const androidDetails = AndroidNotificationDetails(
    'lifemood_channel',
    'Lifemood 알림',
    channelDescription: '감정 기록을 위한 알림 채널',
    importance: Importance.max,
    priority: Priority.high,
  );

  const iosDetails = DarwinNotificationDetails();

  const platformChannelSpecifics = NotificationDetails(
    android: androidDetails,
    iOS: iosDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    0,
    '오늘의 감정을 기록해보세요!',
    '기록 버튼을 눌러 오늘을 돌아보세요.',
    platformChannelSpecifics,
    payload: 'open_feeling_editor', // 또는 'navigate_to_record'
  );
}

/// 클릭 시 이동을 위한 콜백 핸들러
void Function()? _notificationClickHandler;

void setNotificationClickHandler(void Function() handler) {
  _notificationClickHandler = handler;
}
