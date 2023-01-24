import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  var flp = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();
    var androidAyari = AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosAyari = DarwinInitializationSettings();
    var kurulumAyari =
        InitializationSettings(android: androidAyari, iOS: iosAyari);
    await flp.initialize(kurulumAyari,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
  }

  Future<void> bildirimGoster() async {
    var androidBildirimDetayi = const AndroidNotificationDetails(
        "kanalid", "kanal başlık",
        channelDescription: "kanal içerik",
        priority: Priority.high,
        importance: Importance.max);
    var iosBildirimDetayi = DarwinNotificationDetails();
    var bildirimDetayi = NotificationDetails(
        android: androidBildirimDetayi, iOS: iosBildirimDetayi);

    await flp.show(0, "Başlık", "Merhaba", bildirimDetayi,
        payload: "Payload İçerik");
  }

  Future<void> periyodikBildirimGoster() async {
    var androidBildirimDetayi = const AndroidNotificationDetails(
        "kanalid", "kanal başlık",
        channelDescription: "kanal içerik",
        priority: Priority.high,
        importance: Importance.max);
    var iosBildirimDetayi = DarwinNotificationDetails();
    var bildirimDetayi = NotificationDetails(
        android: androidBildirimDetayi, iOS: iosBildirimDetayi);

    var location = await FlutterNativeTimezone.getLocalTimezone();

    tz.setLocalLocation(tz.getLocation('America/Detroit'));

    var gecikme = tz.TZDateTime.now(tz.local).add(Duration(seconds: 10));

    await flp.zonedSchedule(0, "Başlık", "Merhaba", gecikme, bildirimDetayi,
        payload: "Payload İçerik",
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
